---
name: wt
description: Create numbered git worktrees with live discovery in tmux-sessionizer
---

# wt

Use `wt` to create a numbered sibling worktree for a branch in this dotfiles
setup. `wt` does not manage removal or tmux sessions.

## Usage

```sh
wt add                 # pick an existing branch via fzf
wt add <branch>        # check out an existing branch
wt add -b <branch>     # create and check out a new branch
```

Run it from any worktree of the repository, including the main worktree.
Invalid arguments and use outside a Git repository fail with an error.

## Naming and numbering

The new worktree is a sibling of the main worktree named
`<root>_<N>_worktree`, where `<root>` is the main worktree directory name.
At creation time, `wt` queries Git's live `git worktree list --porcelain`
records and uses one more than the largest existing matching number.

## Project discovery

`~/.project_dirs` is a registry of root repositories only. `wt` never adds a
numbered worktree to it. `tmux-sessionizer` expands each root into its live
worktrees by querying Git, and displays their paths and branches in its picker.

To remove a worktree, do so manually with Git:

```sh
git worktree remove <path>
git worktree remove --force <path>  # explicitly override dirty-worktree protection
```

There is intentionally no `wt remove` or `wt rm` command.
