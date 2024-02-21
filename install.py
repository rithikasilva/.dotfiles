import os
from pathlib import Path
import subprocess


RED = "\033[0;31m"
END = "\033[0m"
GREEN = "\033[0;32m"


def setup():
    os.system("sudo dnf update")
    os.system("sudo dnf install stow")
    os.system("sudo dnf install curl")


def bashrc_insert_line(line):
    try:
        with open(Path.home() / ".bashrc", "r+") as f:
            if line not in f.read():
                f.write("\n" + line + "\n")
    except Exception as e:
        print(f"Error with adding {line} to .bashrc")
        print(e)
        return False
    return True


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
    return bashrc_insert_line('eval "$(starship init bash)"')


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
        if os.system("sudo dnf install tmux") != 0:
            print("Couldn't install tmux")
        else:
            if os.system("stow tmux") != 0:
                print("Couldn't apply tmux config")

def tmux_by_default():
    return bashrc_insert_line('. "$HOME/.dotfiles/bash/.tmux_default"')

'''
NVIM:
- Ensure NVIM isn't already installed, assumes rustup is installed
- Install rustup
- Remove NVIM if already installed and version < 0.8.0
- Install NVIM using bob with version >= 0.8.0
- Stow my config
'''


def install_nvim():
    os.system("sudo dnf remove neovim")
    os.system("sudo snap remove nvim")
    os.system("cargo install bob-nvim")
    os.system("bob use 0.9.0")
    os.system("stow nvim")
    return bashrc_insert_line('export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"')



def install_i3():
    os.system("sudo dnf install i3")
    os.system("stow i3")

def install_polybar():
    os.system("sudo dnf install polybar")
    os.system("stow polybar")



def add_scripts_to_path():
    return bashrc_insert_line("export PATH=$PATH:/home/r1tz/.dotfiles/scripts")    

def add_aliases():
    return bashrc_insert_line('. "$HOME/.dotfiles/bash/.bash_aliases"')


def cargo_installs():
    os.system("cargo install bat")
    os.system("cargo install skim")
    os.system("cargo install ripgrep")


def grab_fonts():
    os.system(
        "wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip")


setup()
add_aliases()
add_scripts_to_path()

install_tmux()
tmux_by_default()

install_i3()

install_polybar()

install_starship()

install_nvim()
cargo_installs()



grab_fonts()

print(GREEN + "\n\nPLEASE RESTART SHELL TO SEE CHANGES\n\n" + END)
