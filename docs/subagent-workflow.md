# End-to-end Herdr subagent runs

For the usual delegated task, use `scripts/dev-env/subagent-run`. It composes
`wt-for-subagent`, `subagent-launch`, `herdr agent wait`, and
`wt-for-subagent-cleanup` without replacing their safety checks:

```sh
scripts/dev-env/subagent-run \
  --branch fix-shell-quoting \
  --name shell-quoting \
  --persona implementor \
  -- "Implement the requested shell quoting fix and commit it."
```

The command creates a reserved sibling worktree and a Herdr workspace, waits
for the agent to become `idle`, `done`, or `blocked`, and prints the persistent
report under `~/.herdr-reports/`. The default is manual-audit mode: the Herdr
tab, worktree, and branch remain available for review.

After reviewing the report and the branch, integrate the desired commit(s)
(usually with `git cherry-pick`). To request explicit cleanup in the same
invocation, add `--cleanup integrate` or `--cleanup discard`. After the report
is displayed, the command requires typing `INTEGRATE` or `DISCARD`
respectively, then closes the parsed workspace with `herdr workspace close
<workspace_id>` and invokes the cleanup helper. It never closes a focused or
unrelated workspace. Both acknowledged outcomes use the cleanup helper's
guarded force-branch path: `INTEGRATE` confirms the reported commits were
cherry-picked (which Git cannot identify as a merge), while `DISCARD`
intentionally abandons them. The helper still refuses uncommitted changes. If
workspace closure fails, the worktree is retained; if worktree cleanup fails
after closure, the remaining path is printed for inspection.

A timed-out or blocked run still surfaces the report (if present) and returns
the wait status. No cleanup is attempted unless the explicit acknowledgement
is supplied.
