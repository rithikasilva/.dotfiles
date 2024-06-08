# Waybar
cd ~/.dotfiles/waybar/.config/waybar
rm style.css && ln -s catppuccin.css style.css

# Alacritty
sed -i '/import = \[/c\import = ["~/.config/alacritty/catppuccin-mocha.toml"]' ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml

# Nvim
sed -i "s/^vim.cmd 'colorscheme .*/vim.cmd 'colorscheme catppuccin'/" ~/.dotfiles/nvim/.config/nvim/init.lua

#VSCode
sed -i 's/"workbench.colorTheme".*/"workbench.colorTheme": "Catppuccin Mocha",/' ~/.dotfiles/Code/.config/Code/User/settings.json

# Rofi
sed -i 's|^@theme.*|@theme "/home/r1tz/.local/share/rofi/themes/catppuccin-mocha.rasi"|' ~/.dotfiles/rofi/.config/rofi/config.rasi


# Tmux
# No changes required

# Obsidian
sed -i 's/"cssTheme": "[^"]*"/"cssTheme": "AnuPpuccin"/' ~/Documents/Vaults/Bastion/.obsidian/appearance.json
reload_obsidian.sh

# Firefox



# Wallpaper
chbg ~/Documents/Wallpapers/Catppuccin/evening-sky.png
swaymsg reload
