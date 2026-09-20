# Herdr Migration Spec

## Realization

Herdr replaces tmux as primary daily driver — not launched from within
tmux, but the top-level session manager.

Driver: agents-first workflow. Agents write most code; I review. Coding
agents manage their own subagent concurrency now, so Herdr no longer
needs to orchestrate a custom worktree/persona/cleanup pipeline
(`subagent-run`, `wt-for-subagent`, `implementor`/`reviewer` personas).
Herdr's remaining job: show which agent sessions are running/done/
blocked, let me switch into them — same role tmux sessions play for
human work, but agent-aware.

tmux stays installed, fully independent — no kitty toggle, no bridge —
as a fallback. Keybind parity between tmux and Herdr stays, independent
of any integration.

## Plan

1. Human-first Herdr setup (tmux replacement for everyday use):
   - `ts`-equivalent: fzf project picker → opens/switches a Herdr
     workspace at that path.
   - Keep keybind parity (mostly done in `herdr/.config/herdr/config.toml`).
2. Decouple kitty from Herdr: retire `herdr_toggle.py`'s bridge role;
   kitty just runs Herdr directly.
3. ~~Re-evaluate subagent pipeline (`docs/subagent-workflow.md`,
   `subagent-run`, `wt-for-subagent*`) once Herdr is primary.~~ **Done —
   retired.** Removed `docs/subagent-workflow.md`, `subagent-run`,
   `subagent-launch`, `wt-for-subagent`, `wt-for-subagent-cleanup`,
   the `pi` personas (`implementor`/`investigator`/`reviewer`), the
   `herdr-subagents` skill, and the kitty↔herdr `herdr_toggle.py`
   bridge. Agents now manage their own subagent concurrency; this
   custom pipeline is no longer needed.

## Open questions

## Follow-up questions
