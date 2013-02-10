# L. Weinzierl 2013
# CAREFUL, this script removes configuration files.
# Only run this if you know what you are doing.

# Vim
rm -ri $HOME/.vim
ln -s $HOME/.dotfiles/vim $HOME/.vim
rm -i $HOME/.vimrc
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc

# Git
rm -i $HOME/.gitconfig
ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig
rm -i $HOME/.gitignore
ln -s $HOME/.dotfiles/gitignore $HOME/.gitignore

# GNU Screen
rm -i $HOME/.screenrc
ln -s $HOME/.dotfiles/screenrc $HOME/.screenrc

# login
rm -i $HOME/.hushlogin
ln -s $HOME/.dotfiles/hushlogin $HOME/.hushlogin

