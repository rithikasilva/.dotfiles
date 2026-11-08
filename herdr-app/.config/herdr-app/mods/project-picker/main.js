// Project/worktree picker for the directories registered in ~/.project_dirs.
//
// The registry is the only thing that has to be right to open the picker, so
// that is all it waits for. Opening goes:
//   1. Instantly: the registered roots, read in-process (no git, no subprocess),
//      merged with the last scan's worktrees/branches kept in shared state.
//   2. In the background: one parallel scan refreshes branches and worktrees and
//      drops registered paths that no longer exist. The list updates when it lands.
// On a remote machine there is no local registry to read, so only the scan runs.

import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { closeOverlay, exec, home, panes, props, readTextFile, run, setShared, shared, spaces, theme } from "herdr";

// Per root ($1): "root<TAB>path<TAB>branch" for the root and each linked worktree,
// or "root<TAB>!<TAB>" when the root is gone. Runs for every root, 8 at a time.
const ONE_ROOT = String.raw`root="$1"; [ -n "$root" ] || exit 0
[ -d "$root" ] || { printf '%s\t!\t\n' "$root"; exit 0; }
branch=$(git -C "$root" branch --show-current 2>/dev/null || :)
printf '%s\t%s\t%s\n' "$root" "$root" "$branch"
top=$(git -C "$root" rev-parse --show-toplevel 2>/dev/null || :)
if [ "$top" = "$root" ]; then
  git -C "$root" worktree list --porcelain 2>/dev/null | awk -v root="$root" '/^worktree / {p=substr($0,10)} /^branch / {b=substr($0,19)} /^$/ {if (p != "" && p != root) print root "\t" p "\t" b; p=""; b=""}'
fi`;
const shellQuote = (text) => `'${text.replace(/'/g, `'\\''`)}'`;
const SCAN = String.raw`test -s "$HOME/.project_dirs" || exit 0; tr '\n' '\0' < "$HOME/.project_dirs" | xargs -0 -n1 -P8 sh -c ${shellQuote(ONE_ROOT)} _`;

function matchingSpace(path, machine) {
  const tabIds = new Set(panes().filter((pane) => pane.cwd === path).map((pane) => pane.tab));
  return spaces().find((space) => (space.machine ?? null) === machine && space.tabs.some((tab) => tabIds.has(tab.id)));
}

function displayPath(path) {
  const userHome = home();
  return path === userHome ? "~" : path.startsWith(`${userHome}/`) ? `~${path.slice(userHome.length)}` : path;
}

export default class ProjectPicker extends View {
  init(_initialProps, cx) {
    this.entries = []; // { path, branch, root }
    this.filter = "";
    this.at = 0;
    this.error = null;
    this.scanning = true;
    const scope = shared("dotfiles.machine-scope");
    this.machine = scope && scope !== "local" && scope !== "all" ? scope : null;
    this.cacheKey = `dotfiles.project-index.${this.machine ?? "local"}`;
    this.cached = shared(this.cacheKey) ?? null; // { entries, missing } from the last scan
    this.input = InputState.new({ placeholder: "Find a registered project or worktree…" });
    this.input.on("change", (_event, cx) => {
      this.filter = this.input.value();
      this.at = 0;
      cx.notify();
    });
    this.input.on("submit", () => this.open(this.filtered()[this.at]));
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    cx.spawn(async (cx) => {
      const roots = await this.readRoots();
      this.showRegistered(roots);
      cx.notify();
      await this.scan(roots);
      this.scanning = false;
      cx.notify();
    });
  }

  // The registered roots, in file order. Local only: a remote machine's home isn't known here.
  async readRoots() {
    if (this.machine) return [];
    try {
      const text = await readTextFile(`${home()}/.project_dirs`);
      return [...new Set((text ?? "").split("\n").map((line) => line.trim()).filter(Boolean))];
    } catch {
      return [];
    }
  }

  // Step 1: what the last scan knew (for roots still registered) plus roots it hasn't seen yet.
  showRegistered(roots) {
    if (!roots.length) {
      this.entries = this.cached?.entries ?? [];
      return;
    }
    const registered = new Set(roots);
    const missing = new Set(this.cached?.missing ?? []);
    const known = (this.cached?.entries ?? []).filter((entry) => registered.has(entry.root));
    const seenRoots = new Set(known.map((entry) => entry.root));
    this.entries = [...known, ...roots.filter((root) => !seenRoots.has(root) && !missing.has(root)).map((root) => ({ path: root, branch: "", root }))];
  }

  // Step 2: refresh branches and worktrees, and learn which roots are gone.
  async scan(roots) {
    try {
      const result = await exec("sh", ["-c", SCAN], { on: this.machine });
      if (result.code !== 0) throw new Error((result.stderr || "Could not load projects.").trim());
      const byRoot = new Map();
      const missing = [];
      for (const line of result.stdout.split("\n")) {
        if (!line) continue;
        const [root, path, branch = ""] = line.split("\t");
        if (path === "!") missing.push(root);
        else if (path) byRoot.set(root, [...(byRoot.get(root) ?? []), { path, branch, root }]);
      }
      // File order for registered roots; first-seen order when there is no local file (remote).
      const order = roots.length ? roots : [...byRoot.keys()];
      const seen = new Set();
      const entries = order.flatMap((root) => byRoot.get(root) ?? []).filter((entry) => !seen.has(entry.path) && seen.add(entry.path));
      this.entries = entries;
      this.error = null;
      const next = { entries, missing };
      if (JSON.stringify(next) !== JSON.stringify(this.cached)) setShared(this.cacheKey, next);
    } catch (error) {
      // Keep showing what we have; only say so when there is nothing to show.
      if (!this.entries.length) this.error = error instanceof Error ? error.message : "Could not load projects.";
    }
  }

  filtered() {
    const terms = this.filter.toLowerCase().trim().split(/\s+/).filter(Boolean);
    return this.entries.filter((entry) => {
      const text = `${entry.path} ${entry.branch}`.toLowerCase();
      return terms.every((term) => text.includes(term));
    });
  }

  close() {
    closeOverlay(props().overlay);
  }

  open(entry) {
    if (!entry) return;
    this.close();
    const existing = matchingSpace(entry.path, this.machine);
    if (existing) run("space.select", { id: existing.id });
    else run("space.new", { folder: entry.path, machine: this.machine ?? "" });
  }

  render(cx) {
    const t = theme();
    const entries = this.filtered();
    this.at = Math.max(0, Math.min(this.at, entries.length - 1));
    return v_flex()
      .id("project-picker")
      .w_full()
      .min_h(0)
      .p(18)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .on_key_down((event, cx) => {
        if (event.key === "escape") return this.close();
        if (event.key === "down" && entries.length) this.at = (this.at + 1) % entries.length;
        else if (event.key === "up" && entries.length) this.at = (this.at + entries.length - 1) % entries.length;
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(h_flex().items_center().gap(10).child(div().flex_1().text_size(15).font_semibold().text_color(t.foreground).child("Projects")).when(this.scanning, (element) => element.child(div().text_size(11).text_color(t.dim).child("Refreshing…"))).child(div().text_size(11).text_color(t.dim).child("Esc")))
      .child(
        h_flex().h(36).flex_none().px(10).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
          .child(Input.new(this.input).flex_1().h_full().text_size(12.8).text_color(t.foreground)),
      )
      .child(
        v_flex()
          .min_h(0)
          .max_h(320)
          .overflow_y_scroll()
          .gap(2)
          .children(entries.map((entry, index) =>
            h_flex()
              .id(`project-${index}`)
              .px(10)
              .py(8)
              .rounded(7)
              .gap(12)
              .items_center()
              .cursor_pointer()
              .when(index === this.at, (element) => element.bg(t.hover))
              .hover((style) => style.bg(t.hover))
              .on_click(() => this.open(entry))
              .child(div().flex_1().truncate().text_color(t.foreground).child(displayPath(entry.path)))
              .when(Boolean(entry.branch), (element) => element.child(div().flex_none().text_size(11).text_color(t.ansi3).child(`[${entry.branch}]`))),
          ))
          .when(!this.error && entries.length === 0, (element) => element.child(div().px(10).py(8).text_color(t.dim).child(this.scanning ? "Loading…" : "No registered projects match.")))
          .when(Boolean(this.error), (element) => element.child(div().px(10).py(8).text_color(t.blocked).child(this.error))),
      );
  }
}
