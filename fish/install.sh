#!/bin/bash

# config.fish and fish_plugins are deployed by `stow fish` from init.sh, so this
# script only installs the plugin manager and the plugins it declares.

if ! command -v fish > /dev/null; then
  echo 'fish is not installed - install it first, then re-run this script'
  exit 1
fi

echo 'Installing fisher (fish plugin manager)'
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
echo 'Installing fish plugins from fish_plugins'
fish -c "fisher update"
echo 'Configure look and feel of terminal prompt'
fish -c "tide configure"
