# Dotfiles Repository

This repository is managed with GNU Stow. Most top-level directories are Stow packages whose contents mirror paths under `$HOME`.

## Rules

- Edit files in this repository, not their installed paths in `$HOME`.
- After changing a package, run `stow <package>` from the repository root to install or refresh its symlinks.
- Use `stow --simulate <package>` first when checking for conflicts.
- Do not use `--adopt` or `--override` automatically; existing files may contain user data.
- Keep runtime state, credentials, caches, and generated files out of the repository.

## Shared skills

`skills/.skills/` is the canonical source for shared Agent Skills. The `skills/.claude/skills/` entries are Stow-managed symlinks that expose those skills to Claude Code. Keep shared skill content in `skills/.skills/` and do not edit installed copies under `~/.claude/skills/`.

Claude-only skills may remain outside the shared tree.

## Subagent worktrees

Subagent worktrees (created via `scripts/dev-env/wt-for-subagent`, named
`*_agent_*_worktree`, hidden from `tmux-sessionizer`) must be removed with
`scripts/dev-env/wt-for-subagent-cleanup --path <worktree-path>`, never with
a hand-run `git worktree remove`/`git branch -D`. The script enforces the
safety checks (reserved naming, clean tree, cherry-picked-before-delete) —
see the `wt` and `herdr-subagents` skills for the full workflow.

## Verification

Useful commands:

```sh
git status --short
stow --simulate <package>
stow <package>
ls -la ~/.claude/skills
```
