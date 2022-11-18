#! /bin/bash

present_dir=$(pwd)
SCRIPT_BASE_DIR="$(dirname "$BASH_SOURCE")"

# Clean up current common config
echo 'Clean up current VIM config'
rm -rf $HOME/.vimrc
rm -rf $HOME/vim


echo "Currently in $SCRIPT_BASE_DIR"
echo "Deleting previous .vimrc"
rm -rf ~/.vimrc
echo "Making soft link of .vimrc in ~/.vimrc"
ln -s $SCRIPT_BASE_DIR/.vimrc ~/.vimrc
echo "Completed creation of .vimrc soft link"
echo "Deleting previous .vim folder"
rm -rf ~/.vim
echo "Creating new .vim and adding custom colorscheme"
mkdir ~/.vim
ln -s $SCRIPT_BASE_DIR/colors/ ~/.vim/colors
echo "Cloning and Installing Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "Vundle Installation complete"
echo "Installing plugins"
vim +PluginInstall +qall
