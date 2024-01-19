## Prerequisites
- Python3 is installed.
- rustup is installed.
- A C compiler is installed.


## Installing
After cloning the repo, navigate to the root of the repo and run `python3 install.py`. This will install and setup:
- Neovim (0.9.0) -> LazyVim
- Tmux (3.2a)
- Starship

Note that this will uninstall any existing installation of Neovim to avoiding conflicting with [bob](https://github.com/MordechaiHadad/bob) (my preffered choice of Neovim management).


### Troubleshooting
- Neovim:
  - `:checkhealth` is your best friend.
  - `:TSUpdate` is also your friend.

