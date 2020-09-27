# https://wiki.archlinux.org/index.php/zsh#Command_completion
autoload -Uz compinit promptinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEMES=$HOME/.zsh/themes
ZSH_PLUGIN=$HOME/.zsh/plugins

###########
# Plugins #
###########
source $ZSH_PLUGIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGIN/zsh-syntax-highlighting-filetypes.zsh
source $ZSH_PLUGIN/git.zsh

###########
# Themes #
###########
source $ZSH_THEMES/powerlevel10k/powerlevel10k.zsh-theme
source $ZSH_THEMES/.purepower

##############
# Completion #
##############
# https://wiki.archlinux.org/index.php/zsh#Command_completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

setopt COMPLETE_ALIASES
zstyle ':completion::complete:*' gain-privileges 1

# Add Amazon tab completions
# https://sage.amazon.com/questions/234286?
# https://sage.amazon.com/questions/114697?#209323
SITE_FUNCTIONS=$(echo /usr/local/share/zsh/site-functions | awk '{print $1}')
fpath=($SITE_FUNCTIONS $fpath)
autoload -U $SITE_FUNCTIONS/*(:t)
#####################
# Vim mode bindings #
#####################
bindkey -v
# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history
# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
# reverse history search
bindkey '^r' history-incremental-search-backward

###########
# Aliases #
###########
# amzn aliases
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

# dev env aliases
# alias selenium-server3='java -Dwebdriver.chrome.driver=/Users/alanjos/Documents/cartqa_files/chromedriver -jar ~/Documents/cartqa_files/selenium-server-standalone-3.141.59.jar -port 5555'
# alias selenium-server='java -Dwebdriver.chrome.driver=/Users/alanjos/Downloads/chromedriver -jar ~/Downloads/selenium-server-standalone-2.53.1.jar -port 5555'
# alias odin="ssh -fNL 2009:127.0.0.1:2009 alanjos.aka.corp.amazon.com"
# alias jcd="ssh -fNL 13001:localhost:13001 dev-dsk-alanjos-1b-34afe678.eu-west-1.amazon.com"
# alias bpath="echo RCXQA_CONFIG_OVERRIDE && brazil-path testbuild.configfarm.brazil-config,config,webapps,ApolloCmd && echo CORAL_CONFIG_PATH && brazil-path run.coralconfig"
# alias mrdp="ssh -fNL 13390:localhost:3389 dev-dsk-alanjos-1b-34afe678.eu-west-1.amazon.com"
alias cdesk="ssh clouddesk"

# my aliasies
alias ctags="`brew --prefix`/bin/ctags"
alias tmux-reload='tmux source-file ~/.tmux.conf'
alias tmux="env TERM=xterm-256color tmux"                                       # to support true color in vim in tmux.

###########
# History #
###########
# number of lines kept in history
export HISTSIZE=1000
# number of lines saved in the history after logout
export SAVEHIST=1000
# location of history
export HISTFILE=~/.zsh_history
# append command to history file once executed
setopt inc_append_history
# only show past commands that include the current input
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

########
# Misc #
########
# Automatically use cd when paths are entered without cd
setopt autocd

#############
# Variables #
#############
# Default applications
export EDITOR=nvim
export BROWSER=firefox
# more colors
export TERM=xterm-256color
# path variable
export PATH=$HOME/bin:$HOME/.toolbox/bin:$PATH
# to fix Warning: Failed to set locale category * to *.
export LC_ALL=en_US.UTF-8
# for android development
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home