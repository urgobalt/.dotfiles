clear

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
bindkey -e

# End of lines configured by zsh-newuser-install
# Plugins

source "$HOME/.local/share/miniplug.zsh"

miniplug plugin 'zsh-users/zsh-completions'
miniplug plugin 'supercrabtree/k'
miniplug plugin 'zsh-users/zsh-syntax-highlighting'
miniplug plugin 'zsh-users/zsh-autosuggestions'
miniplug plugin 'unixorn/fzf-zsh-plugin'

miniplug load

[ -f /usr/share/autojump/autojump.zsh ]; source /usr/share/autojump/autojump.zsh

# End of plugins
# Custom aliases

alias ll='k -Ah'
alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias n='nvim .'
alias cw='cargo watch'
alias shutdown='mnt/c/WINDOWS/system32/cmd.exe --terminate $WSL_DISTRO_NAME'
alias reboot='cd /mnt/c/ && mnt/c/WINDOWS/system32/cmd.exe /c start "rebooting WSL" cmd /c "timeout 5 && wsl -d $WSL_DISTRO_NAME" && wsl.exe --terminate $WSL_DISTRO_NAME'
alias start='/mnt/c/Program\ Files/PowerShell/7/pwsh.exe -c start'
alias ga='git add'
alias gc='git commit'
alias gr='git remove'
alias gp='git push'
alias gw='git worktree'
alias gwa='git worktree add'
alias gwr='git worktree remove'

take() {
    if [[ $# -lt 1 ]]
    then
        echo "take: Missing operand (please input directory)"
        return
    fi

    mkdir $1
    cd $1
}

astro-update() {
    cd 
    config fetch AstroNvim main
    config subtree pull --prefix .config/nvim AstroNvim main --squash
    cd -
}

# End of custom aliases
# Prompt config

eval "$(starship init zsh)"

# End of prompt config
# Startup hook

echo

keep_current_path() {
  printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
}
precmd_functions+=(keep_current_path)
source /usr/share/nvm/init-nvm.sh

source "$HOME/.scripts/worktree-traveler.sh"

pfetch
