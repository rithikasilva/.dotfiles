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

(all planned items done — see git history)

## Open questions

## Follow-up questions
