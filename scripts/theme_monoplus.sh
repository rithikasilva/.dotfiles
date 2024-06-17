# Waybar
cd ~/.dotfiles/waybar/.config/waybar
rm style.css && ln -s monochrome.css style.css

# Alacritty
sed -i '/import = \[/c\import = ["~/.config/alacritty/monoplus.toml"]' ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml

# Nvim
sed -i "s/^vim.cmd 'colorscheme .*/vim.cmd 'colorscheme sequoia'/" ~/.dotfiles/nvim/.config/nvim/init.lua

# VSCode
sed -i 's/"workbench.colorTheme".*/"workbench.colorTheme": "monoplus",/' ~/.dotfiles/Code/.config/Code/User/settings.json

# Rofi
sed -i 's|^@theme.*|@theme "/home/r1tz/.local/share/rofi/themes/monoplus.rasi"|' ~/.dotfiles/rofi/.config/rofi/config.rasi


# Tmux
# No changes required

# Obsidian
sed -i 's/"cssTheme": "[^"]*"/"cssTheme": "mono black (monochrome, charcoal)"/' ~/Documents/Vaults/Bastion/.obsidian/appearance.json
reload_obsidian.sh


# Firefox


# Dunst
cd ~/.dotfiles/dunst/.config/dunst
rm dunstrc && ln -s monoplus dunstrc
killall dunst

# Wallpaper
chbg ~/Documents/Wallpapers/Monochrome/planets.png


swaymsg reload
