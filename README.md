## My Dotfiles for MacOS

Managed with GNU Stow. See `AGENTS.md` for the stow workflow and `INSTALL.md`
for dependencies.

This is personal tooling, built for my own machines and workflow, not a
general-purpose framework meant for others to adopt as-is. Mostly vibecoded:
much of it (config, scripts, skills) was built through AI-assisted coding
sessions rather than written line by line by hand — use,
fork, or borrow from it at your own judgment.

Changes frequently and without notice — expect things here to move, break,
or be rewritten between visits.

### Neovim

- Uses Neovim's built-in `vim.pack` plugin manager; `vague` is the active theme.
- LSP is configured for Lua, Python, C/C++, OCaml, and Rust (with Mason); `blink.cmp` provides LSP, path, snippet, and buffer completion.
- Leader is Space. Snacks provides `<leader>sf` (files), `<leader>sg` (grep), `<leader>sh` (help), `<leader>sl` (lines), `<leader>sr` (resume), and `<leader>ss` (spelling); `<leader><leader>` opens buffers. `<C-n>` opens the file tree, and `<leader>rq` sends ripgrep results to quickfix.
- Git workflow uses Gitsigns, Fugitive, Git Conflict, and Diffview; hunk commands are under `<leader>h`, and other Git commands under `<leader>g`.
- Obsidian uses `~/Documents/notes`, with daily notes in `daily`; note commands are under `<leader>n` (today, navigation, search, backlinks, and linking).

### Herdr planning

The planning file toolbar can copy the selected Markdown document as formatted
text for Outlook. On macOS it uses Pandoc (`brew install pandoc`) to put rich
text, HTML, and plain text on the clipboard.

### Directory tree

```text
.
├── AGENTS.md
├── .gitignore
├── INSTALL.md
├── README.md
├── herdr/
│   └── .config/herdr/
│       └── config.toml
├── herdr-app/
│   └── .config/herdr-app/
│       ├── keys.json
│       ├── layouts/
│       │   ├── dev.json
│       │   └── planning.json
│       ├── mods/ (custom workspace UI modules)
│       ├── programs.json
│       ├── settings.json
│       └── themes/vague.json
├── kitty/
│   └── .config/kitty/
│       ├── current-theme.conf
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
│       └── settings.json
├── rex/
│   └── .config/rex/
│       └── init.lua
├── scripts/
│   ├── dev-env/
│   │   ├── rex-sessionizer
│   │   ├── tmux-sessionizer
│   │   ├── worktree-helper
│   │   ├── wt
│   │   └── .tmux-sessionizer
│   └── zsh_aliases
├── skills/
│   ├── .claude/skills/ → ../.skills/
│   ├── .codex/skills/ → ../.skills/
│   └── .skills/
│       ├── commit/
│       ├── herdr/
│       ├── tmux-pane/
│       └── wt/
├── starship/
│   └── .config/starship.toml
└── tmux/
    ├── .tmux.conf
    └── .tmux/plugins/ (TPM)
```
