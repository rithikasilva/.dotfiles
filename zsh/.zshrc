# Keep machine-local settings (including credentials) out of the dotfiles repo.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Open the current ZLE command buffer in Neovim with Ctrl-X Ctrl-E.
export EDITOR=nvim
export VISUAL=nvim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Added by cua-driver-rs installer — see https://github.com/trycua/cua
export PATH="/Users/r1tz/.local/bin:$PATH"
