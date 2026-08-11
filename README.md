## My Dotfiles for MacOS

Managed with GNU Stow. See `CLAUDE.md` for the stow workflow and `INSTALL.md`
for dependencies.

This is personal tooling, built for my own machines and workflow, not a
general-purpose framework meant for others to adopt as-is. Mostly vibecoded:
much of it (config, scripts, skills) was built through AI-assisted coding
sessions rather than written line by line by hand — use,
fork, or borrow from it at your own judgment.

Changes frequently and without notice — expect things here to move, break,
or be rewritten between visits.

### Docs

- `docs/usage-bar.md` — tmux Codex/Claude Code usage bar

### Directory tree

```text
.
├── AGENTS.md
├── CLAUDE.md
├── INSTALL.md
├── README.md
├── docs/
│   └── usage-bar.md
├── herdr/
│   └── .config/herdr/
│       └── config.toml
├── kitty/
│   └── .config/kitty/
│       ├── current-theme.conf
│       ├── herdr_toggle.py
│       ├── kitty.conf
│       └── vague.conf
├── nvim/
│   └── .config/nvim/
│       ├── .stylua.toml
│       ├── init.lua
│       ├── lua/
│       │   ├── rg-to-qf.lua
│       │   └── vim-options.lua
│       ├── nvim-pack-lock.json
│       └── plugin/
│           ├── completion.lua
│           ├── git.lua
│           ├── lsp.lua
│           ├── obsidian.lua
│           ├── snacks.lua
│           ├── themes.lua
│           ├── utilities.lua
│           └── whichkey.lua
├── pi/
│   └── .pi/agent/
│       ├── personas/
│       │   ├── implementor.md
│       │   └── investigator.md
│       └── settings.json
├── scripts/
│   ├── dev-env/
│   │   ├── claude-status
│   │   ├── codex-status
│   │   ├── subagent-launch
│   │   ├── tmux-sessionizer
│   │   ├── worktree-helper
│   │   ├── wt
│   │   ├── wt-for-subagent
│   │   └── wt-for-subagent-cleanup
│   └── zsh_aliases
├── skills/
│   ├── .claude/skills/ → ../.skills/
│   ├── .codex/skills/ → ../.skills/
│   └── .skills/
│       ├── commit/
│       ├── herdr/
│       ├── herdr-subagents/
│       ├── tmux-pane/
│       └── wt/
├── starship/
│   └── .config/starship.toml
└── tmux/
    ├── .tmux.conf
    └── .tmux/plugins/ (TPM)
```

