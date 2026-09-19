# Dotfiles Repository

This repository is managed with GNU Stow. Most top-level directories are Stow packages whose contents mirror paths under `$HOME`.

External tool dependencies and how to install them: `INSTALL.md`.

## Rules

- Edit files in this repository, not their installed paths in `$HOME`.
- After changing a package, run `stow <package>` from the repository root to install or refresh its symlinks.
- Use `stow --simulate <package>` first when checking for conflicts.
- Do not use `--adopt` or `--override` automatically; existing files may contain user data.
- Keep runtime state, credentials, caches, and generated files out of the repository.

## Shared skills

`skills/.skills/` is the canonical source for shared Agent Skills. The `skills/.claude/skills/` and `skills/.codex/skills/` entries are Stow-managed symlinks that expose those skills to Claude Code and Codex, respectively. Keep shared skill content in `skills/.skills/` and do not edit installed copies under `~/.claude/skills/` or `~/.codex/skills/`.

Claude-only or Codex-only skills may remain outside the shared tree.

## Verification

Useful commands:

```sh
git status --short
stow --simulate <package>
stow <package>
ls -la ~/.claude/skills
```
