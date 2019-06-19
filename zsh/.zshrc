ZSH_THEMES=$HOME/.zsh/themes
ZSH_PLUGIN=$HOME/.zsh/plugins

autoload -Uz compinit promptinit
compinit

# autoload -Uz promptinit
# promptinit

# Set Theme
source $ZSH_THEMES/powerlevel10k/powerlevel10k.zsh-theme
# source $ZSH_THEMES/.purepower

# Activate plugins
source $ZSH_PLUGIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGIN/zsh-syntax-highlighting-filetypes.zsh
source $ZSH_PLUGIN/git.zsh

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS # Delete an old recorded event if a new event is a duplicate.

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# vim-mode
bindkey -v
# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history
# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# aliases
alias cxh='cd ~/workplace/javacart/src/CartExperienceHorizonteWebapp/'
alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'
alias brc=brazil-recursive-cmd
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'
alias cdesk="ssh clouddesk"

# path variable
export PATH=$HOME/bin:$HOME/.toolbox/bin:$PATH
