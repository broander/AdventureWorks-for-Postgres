#!/bin/bash

###  Setup script to run after codespaces dev container built.
###  Should be run as a postCreateCommand via the devcontainer.json file
###  Dotfiles cloning should not run via github settings, will be run here.
###  Assumes will run as vscode user so home will be home for that user
### Assumes devcontainer.json is calling this script via bash -i aka interactive mode

echo "Installing Developer Requirements"
# make aliases expand and work in the script
shopt -s expand_aliases

#  Go to home directory for user
cd ~ || exit

# setup dotfiles management
# assumes .cfg is already in .gitignore, if not needs to be to avoid recursion problems
#don't need this, git clone creates .cfg directory
#git init --bare "$HOME"/.cfg
# clone dotfiles repository
# repo is private, so url includes github PAT token
git clone --bare https://broander/dotfiles.git "$HOME"/.cfg
#moved next command to postCreateCommand commands so config is defined prior to running the alias below
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
# stash any conflicting dotfiles so can checkout files from repo
config stash
config checkout

# add conda init info for shells
conda init
conda init fish
conda init zsh

# Install powerline
pip install --user powerline-status

# Install TMUX Plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install ohmyfish, and bobthefish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install >install
fish install --noninteractive --path=~/.local/share/omf --config=~/.config/omf
fish omf install bobthefish

# Vundle for VIM
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Install VIM plugins specified in .vimrc
#vim +PlugInstall +qall
vim --clean '+source ~/.vimrc' +PluginInstall +qall

# Install vim-language-server, which requires NPM
sudo npm install -g vim-language-server

# install YTOP system performance tool; requires rust
# install rust first
curl https://sh.rustup.rs -sSf | sh -s -- -y
./.cargo/bin/cargo install ytop

# Install Universal Ctags
cd ~ || exit
mkdir Github
cd Github || exit
git clone https://github.com/universal-ctags/ctags.git
cd ctags || exit
./autogen.sh
./configure #--prefix=/where/you/want # defaults to /usr/local./configure
make
sudo make install
cd ~ || exit

# # YouCompleteMe language completer for VIM
python3 ~/.vim/bundle/YouCompleteMe/install.py --clangd-completer

echo "Developer Requirements Installation Completed"
sleep 3

exit
