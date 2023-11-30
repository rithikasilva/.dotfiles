import os
from pathlib import Path
import subprocess


def setup():
    os.system("sudo apt update")
    os.system("sudo apt install stow")
    os.system("sudo apt install curl")


'''
STARSHIP:
- Install Starship:
    - Run installation cmd
      `curl -sS https://starship.rs/install.sh | sh`
    - Add stow my config
    - Add line in .bashrc if not already there
'''


def install_starship():
    if os.system("curl -sS https://starship.rs/install.sh | sh") != 0:
        print("Couldn't install Starship")
        return False
    if os.system("stow starship") != 0:
        print("Couldn't apply Starship config")
        return False
    try:
        with open(Path.home() / ".bashrc", "a+") as f:
            bash_eval = 'eval "$(starship init bash)"'
            if bash_eval not in f.read():
                f.write(bash_eval)
    except Exception as e:
        print("Error with .bashrc Starship check/appending:")
        print(e)
        return False
    return True


'''
TMUX:
- Ensure TMUX is installed with the correct version
- stow my config (and associated plugins)
'''


def install_tmux():
    try:
        tmux_version = float(subprocess.check_output(
            ['tmux', '-V'], text=True).split(' ')[1].replace("a", ""))
        if tmux_version >= 3.0:
            if os.system("stow tmux") != 0:
                print("Couldn't apply tmux config")
        else:
            print(f"tmux version is below 3.0: {tmux_version}")
    except (subprocess.CalledProcessError, FileNotFoundError):
        if os.system("sudo apt install tmux") != 0:
            print("Coudlnt' install tmux")
        else:
            if os.system("stow tmux") != 0:
                print("Couldn't apply tmux config")


'''
NVIM:
- Ensure NVIM isn't already installed

- Install rustup
- Remove NVIM if already installed and version < 0.8.0
- Install NVIM using bob with version >= 0.8.0
- Stow my config
'''


def install_nvim():
    os.system("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")
    os.system('. "$HOME/.cargo/env"')
    os.system("cargo install bob-nvim")
    os.system("bob use 0.9.0")
    bob_path = 'export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"'
    try:
        with open(Path.home() / ".bashrc", "a+") as f:
            if bob_path not in f.read():
                f.write(bob_path)
    except Exception as e:
        print("Error with installing bob-nvim:")
        print(e)
        return False
    os.system("stow nvim")
    return True


setup()
install_starship()
install_tmux()
install_nvim()
