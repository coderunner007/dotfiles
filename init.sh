#!/bin/bash

TMUX_PLUGINS=$HOME/.tmux/plugins
COMMON_ALIASES=$HOME/.config/alias

# ** This is a script borrowed from https://stackoverflow.com/a/29754866 **


# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# ${PIPESTATUS[0]} with a simple $?, but I prefer safety.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4  ]]; then
      echo 'I’m sorry, `getopt --test` failed in this environment.'
      echo 'Need to install gnu-getopt. Check end of https://stackoverflow.com/a/29754866.'
      exit 1
fi

# option --output/-o requires 1 argument
LONGOPTS=debug,force,output:,verbose
OPTIONS=dfo:v

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0  ]]; then
      # e.g. return value is 1
          #  then getopt has complained about wrong arguments to stdout
              exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

f=n
# now enjoy the options in order and nicely split until we see --
while true; do
  case "$1" in
    -f|--is-fish)
      f=y
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Programming error"
      exit 3
      ;;
  esac
done

CALLING_SCRIPT_BASE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "This is the script base directory for init: $CALLING_SCRIPT_BASE_DIR"
export CALLING_SCRIPT_BASE_DIR

# Clean up current common config
echo 'Clean up current common config'
rm -rf $TMUX_PLUGINS/tpm
rm -rf $COMMON_ALIASES
rm -rf $HOME/.fzf
rm -rf $HOME/.tmux.conf
rm -rf $HOME/.tmux


# Initialize common software
echo 'Initialize tmux config'
ln -s $CALLING_SCRIPT_BASE_DIR/tmux/.tmux.conf $HOME/.tmux.conf
echo 'Installing tmux plugin manager'
git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGINS/tpm
echo 'Install tmux plugins'
$TMUX_PLUGINS/tpm/scripts/install_plugins.sh
echo 'Installing FZF'
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
echo 'Installing zoxide'
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
echo 'Initializing VIM'
$CALLING_SCRIPT_BASE_DIR/vim/vim_init.sh
echo 'Adding common aliases'
mkdir -p $COMMON_ALIASES
ln -s $CALLING_SCRIPT_BASE_DIR/sh/amzn.sh $COMMON_ALIASES/amzn.sh
ln -s $CALLING_SCRIPT_BASE_DIR/sh/common_aliases.sh $COMMON_ALIASES/common_aliases.sh

if [[ $f = y ]]; then
  echo "Initializing fish shell"
  $CALLING_SCRIPT_BASE_DIR/fish/fish_init.sh
else
  echo "Initializing zsh"
  $CALLING_SCRIPT_BASE_DIR/zsh/zsh_init.sh
fi

echo 'Execute the following commands after this script is run:'
echo '1. Install bat for syntax highlighted cat: https://github.com/sharkdp/bat#installation'
echo '2. Install fd for better find: https://github.com/sharkdp/fd#installation'
echo '3. Install tmux plugins using: prefix + I. https://github.com/tmux-plugins/tpm#installing-plugins'
