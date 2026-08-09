import { Type } from "typebox";
import { mkdir, writeFile } from "node:fs/promises";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type Mode = "default" | "accept-edits" | "plan" | "bypass";
interface ModeState { mode: Mode; }

const STATE_ENTRY = "permission-mode-state";
const PLAN_TOOL = "save_plan";
const READ_TOOLS = new Set(["read", "grep", "find", "ls"]);
const EDIT_TOOLS = new Set(["edit", "write"]);
const MODES: Mode[] = ["default", "accept-edits", "plan", "bypass"];
const ALIASES: Record<string, Mode> = { edits: "accept-edits", duck: "plan", yolo: "bypass" };

export default function (pi: ExtensionAPI): void {
  let mode: Mode = "bypass";

  function updateStatus(ctx: ExtensionContext): void {
    const label = `MODE: ${mode.toUpperCase()}`;
    const color = mode === "bypass" ? "warning" : mode === "plan" ? "accent" : "dim";
    ctx.ui.setStatus("permission-mode", ctx.ui.theme.fg(color, label));
  }

  function applyMode(ctx?: ExtensionContext): void {
    const allTools = pi.getAllTools().map((tool) => tool.name);
    const activeTools = mode === "plan"
      ? [...READ_TOOLS, PLAN_TOOL]
      : allTools;
    pi.setActiveTools(activeTools);
    if (ctx) updateStatus(ctx);
  }

  function persistMode(): void {
    pi.appendEntry<ModeState>(STATE_ENTRY, { mode });
  }

  function resolveMode(value: string): Mode | undefined {
    const normalized = value.trim().toLowerCase();
    if (MODES.includes(normalized as Mode)) return normalized as Mode;
    return ALIASES[normalized];
  }

  pi.registerTool({
    name: PLAN_TOOL,
    label: "Save Plan",
    description: "Save or update the current implementation plan. Only available in plan mode.",
    promptSnippet: "Save the current plan to the controlled project plan file",
    parameters: Type.Object({ content: Type.String({ description: "Complete plan in Markdown format" }) }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      if (mode !== "plan") {
        return { content: [{ type: "text", text: "save_plan is only available in plan mode." }], isError: true };
      }
      const sessionId = ctx.sessionManager.getSessionId().replace(/[^a-zA-Z0-9_-]/g, "_");
      const directory = join(ctx.cwd, ".pi", "plans");
      const path = join(directory, `${sessionId}.md`);
      await mkdir(directory, { recursive: true });
      await writeFile(path, params.content, "utf8");
      return {
        content: [{ type: "text", text: `Plan saved to ${path}` }],
        details: { path },
      };
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    const stateEntry = [...ctx.sessionManager.getBranch()]
      .filter((entry) => entry.type === "custom" && entry.customType === STATE_ENTRY)
      .pop() as { data?: ModeState } | undefined;
    if (stateEntry?.data?.mode && MODES.includes(stateEntry.data.mode)) mode = stateEntry.data.mode;
    applyMode(ctx);
  });

  pi.on("tool_call", async (event, ctx) => {
    if (mode === "bypass") return;
    if (mode === "plan") {
      if (READ_TOOLS.has(event.toolName) || event.toolName === PLAN_TOOL) return;
      return { block: true, reason: "Plan mode is read-only except for saving the plan." };
    }
    if (mode === "accept-edits" && (READ_TOOLS.has(event.toolName) || EDIT_TOOLS.has(event.toolName))) return;
    if (mode === "default" && READ_TOOLS.has(event.toolName)) return;
    if (!ctx.hasUI) return { block: true, reason: `${mode} mode requires interactive approval for this tool.` };

    const detail = event.toolName === "bash" ? String(event.input.command ?? "") : JSON.stringify(event.input);
    if (!await ctx.ui.confirm(`Approve ${event.toolName}?`, detail)) {
      return { block: true, reason: "User denied tool call." };
    }
  });

  pi.on("user_bash", async () => {
    if (mode !== "plan") return;
    return { result: { output: "Plan mode blocks shell commands.", exitCode: 1, cancelled: false, truncated: false } };
  });

  pi.registerCommand("mode", {
    description: "Set mode: default, accept-edits, plan, or bypass",
    getArgumentCompletions: (prefix) => [...MODES, ...Object.keys(ALIASES)]
      .filter((value) => value.startsWith(prefix.toLowerCase()))
      .map((value) => ({ value, label: value })),
    handler: async (args, ctx) => {
      const requested = resolveMode(args);
      if (!requested) {
        ctx.ui.notify("Usage: /mode default|accept-edits|plan|bypass", "error");
        return;
      }
      mode = requested;
      applyMode(ctx);
      persistMode();
      ctx.ui.notify(`Mode: ${mode}`, "info");
    },
  });
}
