# Installation Reference

Prefer `cargo install` when available.

| Tool | macOS | Linux |
|---|---|---|
| stow | `brew install stow` | `dnf/apt install stow` |
| git | `brew install git` | `dnf/apt install git` |
| tmux | `brew install tmux` | `dnf/apt install tmux` |
| zsh | ships with macOS | `dnf/apt install zsh` |
| neovim | [bob-nvim](https://github.com/MordechaiHadad/bob) | bob-nvim |
| kitty | `brew install --cask kitty` | distro package |
| starship | `brew install starship` | `dnf/apt install starship` |
| python3 | `brew install python` | `dnf/apt install python3` |
| node | `brew install node` | `dnf/apt install nodejs npm` |
| rust (rustup/cargo) | `rustup` | `rustup` |
| ripgrep | `cargo install ripgrep` | same |
| rust-analyzer | `rustup component add rust-analyzer` | same |
| clippy | `rustup component add clippy` | same |
| lua-language-server | `brew install lua-language-server` / Mason | Mason |
| jedi-language-server | `pip install jedi-language-server` | same |
| clangd | `brew install llvm` | `dnf install clang-tools-extra` / `apt install clangd` |
| ocamllsp | `brew install opam && opam install ocaml-lsp-server` | same |
| herdr | no package manager — build from source, put on PATH | same |
| pi | no package manager — install upstream, put on PATH | same |

Optional (usage-bar): Claude Code, Codex CLI — provide the OAuth creds `claude-status`/`codex-status` read.

tmux/Neovim plugins are fetched at runtime by TPM / `vim.pack`, not installed here.
