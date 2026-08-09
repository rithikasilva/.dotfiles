---
name: herdr-subagents
description: Start a pi subagent in a dedicated herdr workspace/worktree for analysis/review/implementation tasks, and monitor it through herdr. Default to this for subagent delegation in this repo unless the user asks for the plain Agent tool instead. Trigger word "Hagent" (in any user message, e.g. "Hagent this") always means this skill's full flow, overriding whatever default would otherwise apply.
---

# Herdr subagents (pi, dedicated worktree)

Addendum to the `herdr` skill — read that first for the general pane/agent
primitives, ID handling, and safety rules. This skill only covers what's
specific to this dotfiles setup: running `pi` as a subagent, each in its
own isolated git worktree, for work the user wants to watch live in herdr.

Unlike the base skill, do not check `herdr status` before doing anything —
assume the Herdr server is always running on this machine. No in-pane env
var is required to issue control commands from outside a managed pane. If
a herdr/subagent-launch command fails, investigate the server state
reactively at that point rather than checking upfront.

## Worktree and topology rule

**Every subagent gets its own dedicated git worktree and its own herdr
workspace** — never a worktree/workspace shared with another subagent or
with the orchestrator's own session, and never a worktree herdr creates
itself. This applies to implementors and investigators alike, for one
consistent topology: implementors need isolation so concurrent edits can't
collide, and investigators benefit from a stable snapshot instead of
watching the orchestrator's own checkout change under them.

1. Create the worktree with `scripts/dev-env/wt-for-subagent`, not `wt add`
   (that's the human-facing command — see the `wt` skill):

   ```bash
   scripts/dev-env/wt-for-subagent --new-branch <short-task-name> [--repo <path>] [--base <ref>]
   ```

   Prints one JSON line: `{"path":...,"worktree":...,"branch":...,"repo":...,"base":...,"kind":"subagent"}`.
   The worktree is named `<root>_agent_<id>_worktree` — reserved, and
   excluded from `tmux-sessionizer`'s picker — and the branch lives under
   `agent/`. Subagent worktrees are Herdr-owned; they must never appear as
   a tmux session or in the human picker.

2. Launch the subagent into that worktree with `scripts/dev-env/subagent-launch`
   (see Starting the subagent below) — it creates the herdr workspace/tab
   and starts the agent in one call, always a workspace scoped to that one
   worktree.

Do not create a worktree on the subagent's behalf from inside a delegation
task, and do not hand-roll the workspace-create/tab-create/agent-start
sequence when `subagent-launch` covers it.

## Starting the subagent

Use `scripts/dev-env/subagent-launch` — it collapses workspace
create-or-reuse, tab creation, agent start, and prompt submission into one
non-interactive command:

```bash
scripts/dev-env/subagent-launch \
  --worktree <worktree-path-from-wt-for-subagent> \
  --name <short-name> \
  [--persona <persona-name>] \
  -- <self-contained task prompt...>
```

- `--worktree` is required — the path `wt-for-subagent` just printed.
- `--name` must match `[a-z][a-z0-9_-]{0,31}` and be unique among live
  agents (check `herdr agent list` if unsure). No reuse across tasks, ever
  — even an idle tab/agent sitting in a worktree from an earlier task gets
  a fresh name, never picked back up for a new task. A reused pi session
  can silently carry forward mode/permission state from its previous task.
- `--persona <name>` resolves to `~/.pi/agent/personas/<name>.md` (falling
  back to this repo's `pi/.pi/agent/personas/<name>.md` if not yet
  stowed) and is passed as `--append-system-prompt`. See Personas below.
- The prompt goes after `--`. For long/multi-paragraph tasks, use
  `--prompt-file <file>` or `--prompt-file -` (stdin) instead of fighting
  shell quoting.
- `subagent-launch` automatically appends the report-path instruction
  (`~/.herdr-reports/<worktree-basename>/<name>.md`) to the prompt — do
  not construct or repeat that path yourself in the task text.
- It does **not** wait for completion, read output, or close anything —
  see Monitoring below for that, exactly as before.
- On success it prints one JSON line to stdout: `worktree`, `workspace`,
  `tab`, `pane`, `agent`, `persona`, `report`, `workspace_reused`,
  `prompt_submitted`. On failure it does not roll back whatever it already
  created (a partially-set-up workspace/tab/agent is left for you to
  inspect or retry) and reports which stage failed plus every ID it has so
  far, on stderr.
- `pi` has no built-in tool-approval gating (see its own security docs — no
  sandbox, no per-tool approval prompts by default), so a launched agent
  will not stall on a bash approval prompt. If a subagent ever reports
  `working` but never settles, check `herdr agent read <name>` for a stuck
  approval UI before assuming it's just slow.

## Monitoring

Prefer a single `herdr agent wait` call over `ScheduleWakeup` or a manual
sleep loop, but run it as a **background** Bash call rather than a
foreground one:

```bash
herdr agent wait <name> --until idle --until done --until blocked --timeout 600000
```

Pass `run_in_background: true` on the Bash tool call. This still waits for
the agent to settle (or the timeout hits) and still returns as soon as the
agent finishes rather than waiting out a fixed poll interval — but it does
so without occupying a foreground tool call for the whole wait, so you can
keep working (or respond to the user) in the meantime and get notified when
it completes. Do not poll a backgrounded wait or sleep-loop around it; let
the completion notification drive the next step. Use a generous `--timeout`
sized to the task (minutes, not seconds). Reach for `ScheduleWakeup` instead
only if the task is expected to run far longer than is reasonable to hold a
background shell open for (e.g. tens of minutes to hours), or you have no
other work to interleave and would rather free the background slot.

A settle notification can occasionally fire on an intermediate state change
rather than true completion — if the report file doesn't exist yet when you
go to read it, re-check `herdr agent get <name>`; if it's still `working`,
issue another `herdr agent wait` rather than assuming something broke.

For a quick one-off status check without blocking, use:

```bash
herdr agent list                      # every live agent + status, one call
herdr agent get <name>                # single agent's status
```

When a check shows `idle` or `done`, read the result:

```bash
herdr agent read <name> --source recent-unwrapped --lines 120
```

Report the subagent's findings back to the user — don't just say it
started. If it lands `blocked`, read its output before deciding what to
send next.

## Reporting

Terminal scrollback is a lossy result channel — it doesn't survive tab
closure, and some agent UIs render on the alternate screen, which never
enters herdr's scrollback at all. So a subagent's real output is a
**report file it writes itself**, not (only) what `agent read` shows.

Convention: `~/.herdr-reports/<worktree-name>/<agent-name>.md`, centralized
outside any worktree so it survives worktree removal and never risks an
accidental git commit. `subagent-launch` appends this instruction to the
prompt automatically (see Starting the subagent above) — you don't need to
construct or state the path yourself.

Personas that have their own stricter job (like investigator) bake this
report contract directly into the persona file instead — `subagent-launch`
still appends the resolved path, but the persona itself already specifies
the required sections.

After the subagent settles, **read the report file directly**, not just
`agent read` — that's the artifact that's meant to last.

## Personas

A persona is a fixed system-prompt file that gives a pi subagent a
constrained role, so the orchestrator doesn't have to hand-write the same
constraints into every task prompt. Personas live at
`~/.pi/agent/personas/*.md` (stowed from `pi/.pi/agent/personas/` in this
repo) and are attached via `subagent-launch --persona <name>` (see Starting
the subagent above).

Enforcement is prompt-only for now, by design — no `--tools`/
`--exclude-tools` restriction backs a persona's constraints. Treat this as
a "start simple, harden later" stance, not a security boundary.

**`investigator`** (`pi/.pi/agent/personas/investigator.md`): read-only
codebase research. Only searches and reads (plus read-only bash like
`git log`, `git show`, `cat`, `wc`); never edits, writes, or runs mutating
commands. Its only side effect is its report file, whose path and required
sections (Summary / Findings / Open questions) are already specified in
the persona itself.

Default to spawning an investigator (rather than a plain, unpersonaed pi
instance) when the user asks to "investigate" something or otherwise wants
read-only research delegated to a subagent:

```bash
worktree_json=$(scripts/dev-env/wt-for-subagent --new-branch investigate-<topic>)
worktree_path=$(echo "$worktree_json" | jq -r .path)
scripts/dev-env/subagent-launch --worktree "$worktree_path" --name <short-name> \
  --persona investigator -- "Investigate: <question>."
```

**`implementor`** (`pi/.pi/agent/personas/implementor.md`): given a plan
or task description, writes the actual code — edits, writes, and runs
commands freely within its worktree. Runs tests/lints/builds itself and
reports the real pass/fail result when that's reasonable inside the
worktree (and sandbox, once sandboxing lands); when it isn't — missing
network, external services, or infra the worktree/sandbox can't provide —
it proposes the exact command instead of faking a result. It never merges
or signals "ready" itself: it commits its work on its own branch (see
Cherry-picking implementor work below) for the orchestrator to review and
cherry-pick.

Default to spawning an implementor (rather than a plain, unpersonaed pi
instance) for delegated coding work — the pattern used throughout this
session for fixes, features, and doc changes handed off to a subagent:

```bash
worktree_json=$(scripts/dev-env/wt-for-subagent --new-branch <short-task-name>)
worktree_path=$(echo "$worktree_json" | jq -r .path)
scripts/dev-env/subagent-launch --worktree "$worktree_path" --name <short-name> \
  --persona implementor -- "Implement: <task/plan>."
```

## Cleanup

**Tab/agent cleanup is still manual.** Do not close tabs automatically,
even on successful completion — the user wants to audit report files and
subagent behavior for a while before trusting auto-cleanup. Leave the tab
and agent running unless the user asks to close it; the point of using
herdr instead of a background `Agent` call is that the user can inspect
and interact with it themselves. (Once this manual-audit phase builds
confidence, the plan is to auto-close a tab once its report is written and
the orchestrator has read it — blocked/errored tabs would still always be
left open. Not yet implemented; don't do this until this note is updated.)

**Worktree/branch cleanup is scripted, not manual `git worktree remove`.**
After you've closed the tab and no longer need the worktree (its commits
have been cherry-picked elsewhere, or its read-only work is fully
consumed), run:

```bash
scripts/dev-env/wt-for-subagent-cleanup --path <worktree-path>
```

It refuses to touch anything outside the reserved `*_agent_*_worktree`
naming convention, refuses a worktree with uncommitted changes, and — since
the model here is cherry-pick, not merge — refuses to delete a branch that
still has unmerged commits unless you pass `--force-branch` (use that once
you've confirmed the commits you wanted were already cherry-picked
elsewhere). Do not hand-run `git worktree remove`/`git branch -D` on a
subagent worktree; use this script so the safety checks apply every time.

## Cherry-picking implementor work

Subagents never merge and never signal "ready" themselves. Once an
implementor subagent's task settles (`idle`/`done`), the orchestrator
inspects its worktree directly — `git -C <worktree-path> log`, review the
diff/report — and cherry-picks the specific commit(s) it wants onto the
target branch:

```bash
git cherry-pick <commit-sha>
```

Only after that (and after manually closing the tab, per Cleanup above)
does the worktree get removed with `wt-for-subagent-cleanup`.

## Changing which agent gets launched

This skill and `scripts/dev-env/subagent-launch` are written around `pi`
(`herdr agent start ... --kind pi`), because that's what this machine uses.
`herdr agent start --kind` also supports `claude`, `codex`, `gemini`, and
several others — so on a different machine or at work, where the invoked
CLI differs, change the hardcoded `--kind pi` (and the `~/.pi/agent/personas`
persona-resolution path, which is pi-specific) in `subagent-launch` to match
whatever agent binary is actually in use there. There is no runtime flag for
this today; it's a one-line edit in the script, not a per-invocation option.

## When not to use this

Default to a herdr/pi subagent (this skill) for delegation in this repo.
Fall back to the plain `Agent` tool only when the user explicitly asks for
it, or when herdr itself turns out to be unusable (a herdr/subagent-launch
command actually fails — not in a git repo `wt-for-subagent` can branch
from, etc.) — in that case say so before falling back rather than silently
switching.

## Trigger word: "Hagent"

If the user's message contains "Hagent" (e.g. "Hagent this", "use Hagent
to..."), that is a direct instruction to run this skill's full flow —
worktree via `wt-for-subagent`, launch via `subagent-launch`, monitor via
`herdr agent wait`, report file read back — for that task. It overrides the
plain `Agent` tool as a default and does not require the "explicitly asks
for herdr" bar above to be met separately; the word itself is that ask.
