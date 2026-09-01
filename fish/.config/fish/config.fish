set PATH /Users/alanjos/.local/bin /Users/alanjos/bin /Users/alanjos/.toolbox/bin /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /Users/alanjos/Library/Android/sdk/emulator /Users/alanjos/Library/Android/sdk/tools /Users/alanjos/.fzf/bin /opt/homebrew/opt/gnu-getopt/bin $PATH
set PUPPETEER_EXECUTABLE_PATH /opt/homebrew/bin/chromium
set PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1
set COMMON_ALIASES $HOME/.config/alias

###########
# Aliases #
###########
source $COMMON_ALIASES/common_aliases.sh

################
# Key bindings #
################
function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
  for mode in default insert visual
    bind -M $mode ctrl-space accept-autosuggestion
    bind -M $mode \cp up-or-search
    bind -M $mode \cn down-or-search
  end
end
fish_vi_key_bindings
hybrid_bindings
set -g fish_escape_delay_ms 10

# For default case-sensitive sorting
# on Mac. Mac has BSD-sort which is different
# from GNU-sort. BSD-sort has case-insesitive sorting by
# default whereas GNU-sort has case-sensitive sorting by
# default. This is one of the ways in which the BSD version
# can replicate the GNU-sort version's case-sensitivity
set -x LC_COLLATE C
################
#  Initialize  #
################
fnm env --log-level quiet --use-on-cd --version-file-strategy recursive --corepack-enabled --shell fish | source
zoxide init fish | source

if status is-interactive
# Commands to run in interactive sessions can go here
end

#####################
#  FZF keybindings  #
#####################
fzf_configure_bindings \
  --directory=\cf \
  --git_log=\cg \
  --git_status=\cs \
  --processes=\cx

