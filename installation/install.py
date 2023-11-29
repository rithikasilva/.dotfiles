import os

'''
STARSHIP:
- Install Starship:
    - Run installation cmd
      `curl -sS https://starship.rs/install.sh | sh`
    - Add stow my config
    - Add line in .bashrc if not already there
'''
if os.system("curl -sS https://starship.rs/install.sh | sh") != 0:
    print("Couldn't install Starship")
    exit()
if os.system("stow ../starship") != 0:
    print("Couldn't apply Starship config")
    exit()

try:
    with open("~/.bashrc", "a") as f:
        bash_eval = "eval $(starship init bash)"
        if bash_eval not in f.read():
            f.write(bash_eval)
except as e:
    print("Error with .bashrc Starship check/appending:")
    print(e)


'''
TMUX:
- Ensure TMUX is installed with the correct version
- stow my config (and associated plugins)
'''

'''
NVIM:
- Install rustup
- Remove NVIM if already installed and version < 0.8.0
- Install NVIM using bob with version >= 0.8.0
- Stow my config
'''
