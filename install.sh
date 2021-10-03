#!/bin/bash

mkdir -p ~/.config/nvim

ln -sf `pwd`/init.vim $HOME/.config/nvim
ln -sf `pwd`/coc-settings.json $HOME/.config/nvim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

pip install pynvim

# todo: install silversearch and nerd fonts
