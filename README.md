## My Dotfiles for MacOS

Managed with GNU Stow. See `CLAUDE.md` for the stow workflow and `INSTALL.md`
for dependencies.

This is personal tooling, built for my own machines and workflow, not a
general-purpose framework meant for others to adopt as-is. A fair amount of
it (config, scripts, skills) was written with AI coding agents rather than
by hand — use, fork, or borrow from it at your own judgment.

### tmux usage bar

`tmux/.tmux.conf` shows Codex/ChatGPT and Claude Code rate-limit usage
(5-hour + weekly windows) in the status bar, e.g. `Codex 7d:91% Claude
5h:55% 7d:91%`. Backed by `scripts/dev-env/codex-status` and
`scripts/dev-env/claude-status`:

- `codex-status` reads OAuth creds from `~/.pi/agent/codex-accounts.json` /
  `~/.pi/agent/auth.json` / `~/.codex/auth.json` and calls a private
  ChatGPT backend endpoint (undocumented, may break).
- `claude-status` reads the OAuth token Claude Code stores in macOS
  Keychain (`Claude Code-credentials`) and calls
  `api.anthropic.com/api/oauth/usage`. Never refreshes tokens — if the
  stored one is missing/expired it just prints "unavailable".

Both cache their response locally for 60s so tmux's `status-interval`
doesn't hammer either endpoint.

To turn the bar off (e.g. on a machine using a different agent setup),
create `~/.tmux.conf.local` (gitignored) with:

```tmux
set -g @usage-bar-enabled off
```

