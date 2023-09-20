#!/bin/bash

mkdir -p files/root
pushd files/root

# Clone oh-my-zsh repository
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ./.oh-my-zsh

# Install extra plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ./.oh-my-zsh/custom/plugins/zsh-completions

# Get .zshrc dotfile
cp $GITHUB_WORKSPACE/scripts/.zshrc .

popd
