# Installation Reference

## 1. Prerequisites 

```bash
sudo dnf update
sudo dnf install stow curl
```

We need Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Hyprland

```bash
sudo dnf install hyprland
```

### Dunst

```bash
sudo dnf install dunst
```

### Kitty

```bash
sudo dnf install kitty
```

### Starship

```bash
curl -sS https://starship.rs/install.sh | sh
```

Then, add the following line to your `~/.bashrc` file to enable it:

```bash
eval "$(starship init bash)"
```

### TMUX

```bash
sudo dnf install tmux
```

### Neovim

This setup uses `bob` to manage Neovim versions.

```bash
cargo install bob-nvim
bob use 0.11.0
```

Add the `bob`-managed Neovim to your `PATH` by adding this to `~/.bashrc`:

```bash
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
```

### Rofi

```bash
sudo dnf install rofi
```

### Waybar

```bash
sudo dnf install waybar
```

## 3. Additional Tools & Fonts

### Cargo-based Tools

```bash
cargo install bat skim ripgrep
```

### Fonts

I prefer to use the Iosevka Nerd Font.

## 4. Finalizing the Setup

### Add Scripts and Aliases to PATH

Make the custom scripts and aliases available in your shell by adding these lines to your `~/.bashrc`:

```bash
export PATH=$PATH:/home/r1tz/.dotfiles/scripts
. "$HOME/.dotfiles/scripts/.bash_aliases"
```

