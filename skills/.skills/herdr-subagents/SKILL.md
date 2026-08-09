---
name: herdr-subagents
description: Start a pi subagent in a herdr pane inside the current project's worktree for analysis/review tasks, and monitor it through herdr. Use only when explicitly asked to run work as a herdr/pi subagent, not as a general substitute for the Agent tool.
---

# Herdr subagents (pi, same worktree)

Addendum to the `herdr` skill — read that first for the general pane/agent
primitives, ID handling, and safety rules. This skill only covers what's
specific to this dotfiles setup: running `pi` as a subagent, in the same
worktree as the calling session, for analysis/review work the user wants to
watch live in herdr.

Same precondition as the base skill: confirm the Herdr server is actually
running (`herdr status`) before doing anything. No in-pane env var is
required to issue control commands from outside a managed pane.

## Worktree and topology rule

One herdr **workspace** per worktree — that part is unchanged. Never a
different project's worktree, and never a worktree herdr creates itself.
This dotfiles setup keeps worktree lifecycle separate from herdr; use `wt add`
when a new worktree is needed, and manual `git worktree remove` when one is
removed. Herdr only ever attaches to worktrees that already exist. So:

- If a workspace already exists with `cwd` == the target worktree path
  (check `herdr workspace list` / `herdr pane list --workspace <id>`),
  reuse that workspace.
- Otherwise create a new workspace pointed at that path — `herdr workspace
  create --cwd <worktree-path> --no-focus` — not `herdr worktree
  create`/`open`.
- The worktree itself must already exist (created with `wt add`
  beforehand). Do not create one on the subagent's behalf.

Within that workspace, every subagent gets its **own tab** — never a pane
split, never sharing a tab with another subagent. Concurrent subagents in
the same worktree are concurrent tabs, not concurrent panes; this is what
keeps the workspace from getting visually polluted as work piles up.

**No reuse across tasks.** Every new task — even in a worktree that
already has a workspace with idle tabs sitting in it — gets a **new tab
and a new uniquely named agent**. Do not search for an idle tab/agent to
hand the next task to. A reused pi session can silently carry forward
mode/permission state from its previous task, which is exactly the kind
of surprise this rule avoids.

## Starting the subagent

1. Find or create the workspace for this worktree (see above).

2. Create a fresh tab in that workspace for this task:

   ```bash
   herdr tab create --workspace <workspace-id> --cwd <worktree-path> --no-focus
   ```

   Read the new tab's root pane ID from `.result.root_pane.pane_id`.

3. Start `pi` in that pane with a short descriptive name
   (`[a-z][a-z0-9_-]{0,31}`, unique among live agents — check `herdr agent
   list` if unsure):

   ```bash
   herdr agent start <name> --kind pi --pane <pane-id>
   ```

   To give the subagent a **persona** (a fixed role/system-prompt — see
   Personas below), append it as a native `pi` argument after `--`:

   ```bash
   herdr agent start <name> --kind pi --pane <pane-id> -- \
     --append-system-prompt ~/.pi/agent/personas/<persona>.md
   ```

   `pi` defaults to YOLO/bypass mode on this machine (see
   `~/.pi/agent/extensions/modes.ts`), so it will not stall on a bash
   approval prompt. If a subagent ever reports `working` but never settles,
   check `herdr agent read <name>` for a stuck approval UI before assuming
   it's just slow.

4. Submit the task without `--wait`. `pi` has no memory of this
   conversation, so brief it like a subagent: state the goal, relevant
   file paths, and what "done" looks like. Include the report-file
   instruction (see Reporting below) unless the persona already bakes its
   own report contract in.

   ```bash
   herdr agent prompt <name> "<self-contained analysis task>"
   ```

   Do not attach `--wait` to `agent prompt` itself — submit it plain, then
   wait separately (below) so a stalled/gated agent doesn't surface as an
   opaque `agent_prompt_stalled` error on the submit call.

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
outside any worktree so it survives manual worktree removal and never risks
an accidental git commit. The orchestrator already knows both `<worktree-name>` and
`<agent-name>` (it chose them), so construct this exact path and state it
literally in the task prompt:

```
When finished, write a report to ~/.herdr-reports/<worktree-name>/<agent-name>.md
covering: what you did, files touched, and anything you couldn't complete
or want flagged for review. Write this file even if you hit an error.
```

Personas that have their own stricter job (like investigator) bake this
report contract directly into the persona file instead — a task prompt
using such a persona only needs to state the task and the resolved path,
not repeat the full instruction.

After the subagent settles, **read the report file directly**, not just
`agent read` — that's the artifact that's meant to last.

## Personas

A persona is a fixed system-prompt file that gives a pi subagent a
constrained role, so the orchestrator doesn't have to hand-write the same
constraints into every task prompt. Personas live at
`~/.pi/agent/personas/*.md` (stowed from `pi/.pi/agent/personas/` in this
repo) and are attached via `--append-system-prompt` at `agent start` time
(see Starting the subagent above).

Enforcement is prompt-only for now, by design — no `--tools`/
`--exclude-tools` restriction backs a persona's constraints. Treat this as
a "start simple, harden later" stance, not a security boundary.

**`investigator`** (`pi/.pi/agent/personas/investigator.md`): read-only
codebase research. Only searches and reads; never edits, writes, or runs
mutating commands. Its only side effect is its report file, whose path and
required sections (Summary / Findings / Open questions) are already
specified in the persona itself.

Default to spawning an investigator (rather than a plain, unpersonaed pi
instance) when the user asks to "investigate" something or otherwise wants
read-only research delegated to a subagent:

```bash
herdr agent start <name> --kind pi --pane <pane-id> -- \
  --append-system-prompt ~/.pi/agent/personas/investigator.md
herdr agent prompt <name> "Investigate: <question>. Write your report to ~/.herdr-reports/<worktree-name>/<name>.md"
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

**Worktree/branch cleanup, once a subagent used its own dedicated worktree
(created via `wt-for-subagent` — see the `wt` skill), is scripted, not
manual `git worktree remove`.** After you've closed the tab and no longer
need the worktree (its commits have been cherry-picked elsewhere, or its
read-only work is fully consumed), run:

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

## When not to use this

Default to the `Agent` tool for delegation. Only start a herdr/pi subagent
when the user explicitly wants the work running as a live, monitorable pane
(e.g. "run this as a pi subagent in herdr so I can watch it").
