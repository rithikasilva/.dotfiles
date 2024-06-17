# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias tmux='tmux -2'
alias nv='nvim'

alias r6silva-mount="~/.dotfiles/scripts/r6silva_mount.sh"
alias r6silva-umount="~/.dotfiles/scripts/r6silva_umount.sh"

alias typhoon-mount="~/.dotfiles/scripts/typhoon_mount.sh"
alias typhoon-umount="~/.dotfiles/scripts/typhoon_umount.sh"

alias bat="batcat"

alias em="emacs -nw"

function ntfy-maelstrom() {
		curl -d "$1" maelstrom.tail561e2.ts.net/maelstrom
}
