## Programs
- Neovim (>= 0.9)
- Tmux (3.2a)
- [Starship](https://starship.rs/)

## Notes
1. Use [bob](https://github.com/MordechaiHadad/bob) to install NVIM 0.9.0 or higher. Remember to `export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"` otherwise running `nvim` won't work.
2. I use `Starship` since it offers some nice shell-agnostic features (like git info). Make sure to have `eval "$(starship init bash)"` (or whatever line for the shell you are using) to use it instead of the default shell stuff. The install script (being worked on) is only for bash.




## Install Script Requirements
- NVIM is not already installed
- Tmux is not already installed
- Python3 is installed.
- rustup is installed.
- A C compiler is necessary, just `sudo apt install build-essential`


### Troubleshooting
- Ensure all required dependencies are installed before setting up LazyVim.
- `:checkhealth` is your best friend.
- `:TSUpdate` is also your friend.

