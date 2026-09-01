#!/bin/bash

# Bootstraps this machine from the config packages in this repo.
#
# Every package here is a GNU Stow package: its internal tree mirrors $HOME, so
# `stow fish` links fish/.config/fish/config.fish to ~/.config/fish/config.fish.
# Adding a new config file means dropping it in the right place under a package -
# there is nothing to add to this script.
#
# `mac` is deliberately not in the list. It is a reference archive of app exports
# (Raycast, Shortcuts, Karabiner, Phoenix) with no deployable home layout, and its
# .stow-local-ignore makes an accidental `stow mac` a no-op.
STOW_PACKAGES=(fish git nvim sh ssh claude tmux)

TMUX_PLUGINS=$HOME/.tmux/plugins

# More safety, by turning some bugs into errors.
set -o errexit -o pipefail -o noclobber -o nounset

CALLING_SCRIPT_BASE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "This is the script base directory for init: $CALLING_SCRIPT_BASE_DIR"
export CALLING_SCRIPT_BASE_DIR

# Homebrew doubles as the macOS check and as the package manager for the
# installs below. Ask once, up front, so each install can just test for brew
# instead of prompting separately.
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

echo 'Checking for GNU Stow'
if command -v stow > /dev/null; then
  echo 'stow already installed, skipping'
else
  read -r -p 'GNU Stow not found. Install it? [y/N] ' install_stow 2> /dev/null < /dev/tty || install_stow=n
  if [[ $install_stow == [Yy]* ]]; then
    if command -v brew > /dev/null; then
      brew install stow
    elif command -v apt-get > /dev/null; then
      sudo apt-get install -y stow
    elif command -v dnf > /dev/null; then
      sudo dnf install -y stow
    elif command -v pacman > /dev/null; then
      sudo pacman -S --noconfirm stow
    else
      # No package manager available. Stow is Perl + autoconf, so there is no
      # curl-pipe installer upstream - build the GNU tarball into ~/.local.
      # ftpmirror.gnu.org redirects to a nearby mirror.
      STOW_VER=2.4.1
      curl -fsSL "https://ftpmirror.gnu.org/stow/stow-$STOW_VER.tar.gz" | tar -xz -C /tmp
      ( cd "/tmp/stow-$STOW_VER" && ./configure --prefix="$HOME/.local" && make install )
      export PATH="$HOME/.local/bin:$PATH"
    fi
    command -v stow > /dev/null || { echo 'stow install did not put stow on PATH - aborting'; exit 1; }
  else
    echo 'GNU Stow is required to deploy the config packages - aborting'
    exit 1
  fi
fi

# Create the target directories up front. Without them, stow would replace a
# whole missing directory with a single symlink into this repo ("folding") - and
# then ~/.ssh keys or Claude Code's runtime state would get written inside the
# git repo. --no-folding below is the real guard; these mkdirs make the intent
# explicit and keep the ssh permissions right on a fresh machine.
echo 'Deploying config packages with stow'
mkdir -p "$HOME/.config" "$HOME/.claude"
mkdir -p -m 700 "$HOME/.ssh"
# --restow (unstow, then stow) makes re-running this script idempotent.
# Deliberately no --adopt: on a machine with pre-existing configs it would
# silently overwrite this repo's contents with whatever is on disk.
stow --dir="$CALLING_SCRIPT_BASE_DIR" --target="$HOME" --no-folding --restow -v "${STOW_PACKAGES[@]}"

# Initialize common software
echo 'Installing tmux plugin manager'
if [[ -d $TMUX_PLUGINS/tpm ]]; then
  echo 'tpm already cloned, skipping'
else
  git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS/tpm"
fi
echo 'Install tmux plugins'
"$TMUX_PLUGINS/tpm/scripts/install_plugins.sh"
echo 'Installing FZF'
if command -v brew > /dev/null; then
  brew install fzf
  # No post-install script: it only generates ~/.fzf.zsh and ~/.fzf.bash, and zsh/bash
  # are no longer configured here. fish gets its bindings from the fzf.fish plugin
  # (fzf_configure_bindings in fish/.config/fish/config.fish), which calls the fzf
  # binary directly.
else
  # --bin: "Download fzf binary only; Do not generate ~/.fzf.{bash,zsh}". Without it the
  # installer prompts (`read -p "... ([y]/n)"`), so init.sh could not run unattended.
  # It installs to ~/.fzf/bin, which config.fish puts on PATH.
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" && "$HOME/.fzf/install" --bin
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
  # --skip-shell because config.fish already runs `fnm env`.
  # -d ~/.local/bin because the installer's default dir is not on PATH, and
  # config.fish silently no-ops when fnm is missing from PATH.
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --force-no-brew -d "$HOME/.local/bin"
fi

echo 'Installing fish'
if command -v fish > /dev/null; then
  echo 'fish already installed, skipping'
elif command -v brew > /dev/null; then
  brew install fish
elif command -v apt-get > /dev/null; then
  sudo apt-get install -y fish
elif command -v dnf > /dev/null; then
  sudo dnf install -y fish
elif command -v pacman > /dev/null; then
  sudo pacman -S --noconfirm fish
else
  # fish is a Rust build now, so there is no practical source fallback here.
  echo 'No supported package manager found - install fish manually:'
  echo '  https://fishshell.com/#installation'
  echo 'Then re-run this script to set up the plugins.'
fi

echo 'Initializing fish shell'
"$CALLING_SCRIPT_BASE_DIR/fish/install.sh"

echo 'Execute the following commands after this script is run:'
echo '1. Install bat for syntax highlighted cat: https://github.com/sharkdp/bat#installation'
echo '2. Install fd for better find: https://github.com/sharkdp/fd#installation'
echo '3. Install tmux plugins using: prefix + I. https://github.com/tmux-plugins/tpm#installing-plugins'

# fish is installed and configured above, but it is not the login shell until
# chsh is run - and chsh refuses any shell that is not listed in /etc/shells.
if command -v fish > /dev/null; then
  FISH_PATH=$(command -v fish)
  if [[ ${SHELL:-} == "$FISH_PATH" ]]; then
    echo "4. fish is already your default shell - nothing to do."
  else
    echo '4. fish is NOT your default shell yet. To switch:'
    if ! grep -qxF "$FISH_PATH" /etc/shells 2> /dev/null; then
      echo "     echo '$FISH_PATH' | sudo tee -a /etc/shells"
    fi
    echo "     chsh -s '$FISH_PATH'"
    echo '   Then open a new terminal. (Log out and back in on some systems.)'
  fi
fi
