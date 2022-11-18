#!/bin/bash

PLUGINS=$HOME/.zsh/plugins
THEMES=$HOME/.zsh/themes
CACHE=$HOME/.zsh/cache
SCRIPT_BASE_DIR=$CALLING_SCRIPT_BASE_DIR/zsh

# Cleaning up current plugins, themes & config
echo 'Cleaning up zsh config...'
rm -rf $PLUGINS
rm -rf $THEMES
rm -rf $HOME/.p10k.zsh
rm -rf $HOME/.zshrc

# Install plugins
echo 'Downloading plugins...'
mkdir -p $PLUGINS
echo 'Syntax highlighting for commands'
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PLUGINS/zsh-syntax-highlighting
# echo 'Syntax highlighting for filetypes'
# curl https://raw.githubusercontent.com/trapd00r/zsh-syntax-highlighting-filetypes/master/zsh-syntax-highlighting-filetypes.zsh > $PLUGINS/zsh-syntax-highlighting-filetypes.zsh
echo 'Git aliases'
curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/git/git.plugin.zsh > $PLUGINS/git.zsh
echo 'zsh completions'
git clone git://github.com/zsh-users/zsh-completions.git $PLUGINS/zsh-completions
echo 'Auto-suggestion'
git clone https://github.com/zsh-users/zsh-autosuggestions.git $PLUGINS/zsh-autosuggestions
echo 'History search'
git clone https://github.com/zsh-users/zsh-history-substring-search $PLUGINS/zsh-history-substring-search
echo 'Clipboard library functions'
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/clipboard.zsh > $PLUGINS/clipboard.zsh
echo 'Copy file contents to clipboard'
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/copyfile/copyfile.plugin.zsh > $PLUGINS/copyfile.zsh
echo 'Copy directory path to clipboard'
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/copydir/copydir.plugin.zsh > $PLUGINS/copydir.zsh
echo 'Extract any compressed file'
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/_extract > $PLUGINS/_extract
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/extract.plugin.zsh > $PLUGINS/extract.zsh

# Install themes
echo 'Downloading theme ...'
echo 'Downloading and applying powerlevel10k theme...'
mkdir -p $THEMES
git clone https://github.com/romkatv/powerlevel10k.git $THEMES/powerlevel10k
curl https://raw.githubusercontent.com/romkatv/dotfiles-public/master/.purepower > $THEMES/.purepower

echo '\nSoftlinking config files'
(ln -s $SCRIPT_BASE_DIR/.p10k.zsh $HOME/.p10k.zsh;)
(ln -s $SCRIPT_BASE_DIR/.zshrc $HOME/.zshrc;)

# Created directory for cache (history, fasd)
mkdir -p $CACHE

echo '\n May have to rebuild zcompdump for zsh-completions (https://github.com/zsh-users/zsh-completions#manual-installation): rm -f ~/.zcompdump; compinit\n'
echo '\n'
