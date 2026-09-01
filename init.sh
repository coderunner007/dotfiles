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


# Homebrew doubles as the macOS check and as the package manager for the
# installs below. Ask once, up front, so each install can just test for brew
# instead of prompting three separate times.
if ! command -v brew > /dev/null; then
  read -r -p 'Homebrew not found. Install Homebrew? [y/N] ' install_brew 2> /dev/null < /dev/tty || install_brew=n
  if [[ $install_brew == [Yy]* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # A fresh install is not on PATH yet for this script's shell
    for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
      if [[ -x $brew_bin ]]; then
        eval "$($brew_bin shellenv)"
        break
      fi
    done
    command -v brew > /dev/null || echo 'Homebrew install did not put brew on PATH - using the git/curl installers below'
  else
    echo 'Skipping Homebrew - using the git/curl installers below'
  fi
fi

# Initialize common software
echo 'Initialize tmux config'
ln -s $CALLING_SCRIPT_BASE_DIR/tmux/.tmux.conf $HOME/.tmux.conf
echo 'Installing tmux plugin manager'
git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGINS/tpm
echo 'Install tmux plugins'
$TMUX_PLUGINS/tpm/scripts/install_plugins.sh
echo 'Installing FZF'
if command -v brew > /dev/null; then
  brew install fzf
  # Generates ~/.fzf.zsh, which zsh/.zshrc already sources. --no-update-rc so the
  # installer does not append its own source lines to the repo-tracked .zshrc,
  # and --no-fish because fish gets its bindings from the fzf.fish plugin
  # (fzf_configure_bindings in fish/config.fish).
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-fish
else
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
fi
echo 'Installing zoxide'
if command -v brew > /dev/null; then
  brew install zoxide
else
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
echo 'Installing fnm (node version manager)'
if command -v fnm > /dev/null; then
  echo 'fnm already installed, skipping'
elif command -v brew > /dev/null; then
  brew install fnm
else
  # --force-no-brew because this path is only reached when brew is unavailable
  # and the installer otherwise defaults to (and hard-fails on) Homebrew on macOS.
  # --skip-shell because the shell configs in this repo already run `fnm env`.
  # -d ~/.local/bin because the installer's default dir is not on PATH, and the
  # shell configs here silently no-op when fnm is missing from PATH.
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --force-no-brew -d "$HOME/.local/bin"
fi
echo 'Initializing VIM'
$CALLING_SCRIPT_BASE_DIR/vim/vim_init.sh
echo 'Adding common aliases'
mkdir -p $COMMON_ALIASES
ln -s $CALLING_SCRIPT_BASE_DIR/sh/amzn.sh $COMMON_ALIASES/amzn.sh
ln -s $CALLING_SCRIPT_BASE_DIR/sh/common_aliases.sh $COMMON_ALIASES/common_aliases.sh
# echo 'Karbiner elements configre'
# rm -rf $HOME/.config/karabiner/karabiner.json
# ln -s $CALLING_SCRIPT_BASE_DIR/mac/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json
# echo 'Phoenix configure'
# rm -rf $HOME/.phoenix.js
# ln -s $CALLING_SCRIPT_BASE_DIR/mac/.phoenix.js $HOME/.phoenix.js
echo 'Claude Code setup'
mkdir -p $HOME/.claude
ln -s $CALLING_SCRIPT_BASE_DIR/claude/settings.json $HOME/.claude/settings.json
ln -s $CALLING_SCRIPT_BASE_DIR/claude/statusline.sh $HOME/.claude/statusline.sh
ln -s $CALLING_SCRIPT_BASE_DIR/claude/tmux-session-name.sh $HOME/.claude/tmux-session-name.sh

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
