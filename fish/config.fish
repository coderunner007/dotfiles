set PATH /Users/alanjos/.local/bin /Users/alanjos/bin /Users/alanjos/.toolbox/bin /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /Users/alanjos/Library/Android/sdk/emulator /Users/alanjos/Library/Android/sdk/tools /Users/alanjos/.fzf/bin /opt/homebrew/opt/gnu-getopt/bin $PATH
set COMMON_ALIASES $HOME/.config/alias

###########
# Aliases #
###########
source $COMMON_ALIASES/common_aliases.sh
source $COMMON_ALIASES/amzn.sh

################
# Amazon Cards #
################
bash -c "source $HOME/.cardcli_profile"
set PATH $PATH /Users/alanjos/aws-cli/bin
# Hack to set the node & npm executables in path
for dir in $HOME/.nvm/versions/node/*/bin
  set PATH $dir $PATH
end

################
# Key bindings #
################
function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
  for mode in default insert visual
    bind -M $mode -k nul end-of-line accept-autosuggestion
    bind -M $mode \cp up-or-search
    bind -M $mode \cn down-or-search
  end
end
hybrid_bindings
fish_vi_key_bindings
set -g fish_escape_delay_ms 10

################
#  Initialize  #
################
zoxide init fish | source

if status is-interactive
# Commands to run in interactive sessions can go here
end
