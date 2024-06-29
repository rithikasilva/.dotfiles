# Waybar
cd ~/.dotfiles/waybar/.config/waybar
rm style.css && ln -s catppuccin.css style.css

# Alacritty
sed -i '/import = \[/c\import = ["~/.config/alacritty/catppuccin-latte.toml"]' ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml

# Nvim
sed -i "s/^vim.cmd 'colorscheme .*/vim.cmd 'colorscheme catppuccin-latte'/" ~/.dotfiles/nvim/.config/nvim/init.lua

#VSCode
sed -i 's/"workbench.colorTheme".*/"workbench.colorTheme": "Catppuccin Latte",/' ~/.dotfiles/Code/.config/Code/User/settings.json

# Rofi
sed -i 's|^@theme.*|@theme "/home/r1tz/.local/share/rofi/themes/catppuccin-latte.rasi"|' ~/.dotfiles/rofi/.config/rofi/config.rasi


# Tmux
# No changes required

# Obsidian
sed -i 's/"cssTheme": "[^"]*"/"cssTheme": "AnuPpuccin"/' ~/Documents/Vaults/Bastion/.obsidian/appearance.json
reload_obsidian.sh

# Firefox


# Dunst
cd ~/.dotfiles/dunst/.config/dunst
rm dunstrc && ln -s catppuccin dunstrc
killall dunst

# Wallpaper
chbg ~/Documents/Wallpapers/Catppuccin/evening-sky.png
swaymsg reload


# Starhip
cd ~/.dotfiles/starship/.config/
rm starship.toml && ln -s latte.toml starship.toml

