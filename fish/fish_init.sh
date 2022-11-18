#!/bin/bash

FISH_CONFIG_BASE=$HOME/.config/fish
SCRIPT_BASE_DIR=$CALLING_SCRIPT_BASE_DIR/fish

if [[ -z $CALLING_SCRIPT_BASE_DIR ]]
then
  SCRIPT_BASE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fi

echo "This is the script base directory for fish_init: $SCRIPT_BASE_DIR"
echo 'Initialize fish shell'
# Cleaning up current plugins, themes & config
rm -rf $FISH_CONFIG

# Recreate the config directory
mkdir -p $FISH_CONFIG 2> /dev/null

# Use -f option to create soft link because fish keeps creating config files
echo 'Softlinking config files'
ln -sf $SCRIPT_BASE_DIR/config.fish $FISH_CONFIG_BASE/config.fish

# Install plugins
echo 'Installing fundle plugin manager'
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher install IlanCosman/tide"
fish -c "fisher install PatrickF1/fzf.fish"
fish -c "fisher install jhillyerd/plugin-git"
echo 'Configure look and feel of terminal prompt'
fish -c "tide configure"
