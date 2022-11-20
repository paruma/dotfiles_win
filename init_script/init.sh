#!/bin/bash

fs=('.zshrc' '.zprofile' '.gitconfig' '.config')

for f in "${fs[@]}"; do
    # cp -r ~/$f ~/dotfiles/backup/$f
    # mv ~/$f ~/dotfiles/$f
    ln -s ~/dotfiles/$f ~/$f
done