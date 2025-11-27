#!/usr/bin/env bash

mkdir -p files/root

# Clone oh-my-zsh repository
git clone -q --depth=1 https://github.com/ohmyzsh/ohmyzsh.git files/root/.oh-my-zsh

# Install extra plugins
git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git files/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git files/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Get .zshrc dotfile
[[ -f "${GITHUB_WORKSPACE}/scripts/.zshrc" ]] && cp -f "${GITHUB_WORKSPACE}/scripts/.zshrc" files/root/.zshrc

printf "\e[32m[SUCCESS]\e[0m \e[37m%s\e[0m\n" "[${0##*/}] done"
exit 0