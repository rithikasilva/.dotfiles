---
name: wt
description: Create human numbered git worktrees; subagent worktrees are reserved and hidden from tmux-sessionizer
---

# wt

Use `wt` to create a human-oriented numbered sibling worktree for a branch in
this dotfiles setup. `wt` does not manage removal or tmux sessions. The
orchestrator-facing `wt-for-subagent` wrapper is a separate, non-interactive
entry point for subagent worktrees; do not use `wt add` ad hoc for those.

## Usage

```sh
wt add                 # pick an existing branch via fzf
wt add <branch>        # check out an existing branch
wt add -b <branch>     # create and check out a new branch
```

For an isolated subagent worktree, use:

```sh
wt-for-subagent --repo <path> --new-branch <branch> [--base <ref>]
```

This prints one JSON metadata line. Branches without `agent/` are placed in
that namespace; `agent/foo` is used as-is. Run `wt` from any worktree of the
repository, including the main worktree.
Invalid arguments and use outside a Git repository fail with an error.

## Naming and numbering

The new worktree is a sibling of the main worktree named
`<root>_<N>_worktree`, where `<root>` is the main worktree directory name.
At creation time, `wt` queries Git's live `git worktree list --porcelain`
records and uses one more than the largest existing matching number.

## Project discovery

`~/.project_dirs` is a registry of root repositories only. `wt` never adds a
numbered worktree to it. `tmux-sessionizer` expands each root into its live
**human** worktrees by querying Git, and displays their paths and branches in
its picker. Reserved subagent worktrees named
`<root>_agent_<id>_worktree` (and any worktree on an `agent/*` branch) are
deliberately excluded. They are for Herdr workspaces, not tmux sessions.

To remove a worktree, do so manually with Git:

```sh
git worktree remove <path>
git worktree remove --force <path>  # explicitly override dirty-worktree protection
```

There is intentionally no `wt remove` or `wt rm` command.
