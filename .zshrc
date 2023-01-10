# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' '' '' ''
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/urgobalt/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

# End of lines configured by zsh-newuser-install
# Plugins

source "$HOME/.local/share/miniplug.zsh"

miniplug plugin 'zsh-users/zsh-completions'
miniplug plugin 'supercrabtree/k'
miniplug plugin 'zsh-users/zsh-syntax-highlighting'
miniplug plugin 'zsh-users/zsh-autosuggestions'

miniplug load

[ -f /usr/share/autojump/autojump.zsh ]; source /usr/share/autojump/autojump.zsh

# End of plugins
# Custom aliases

alias ls='k'
alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# End of custom aliases
# Prompt config

eval "$(starship init zsh)"

# End of prompt config
