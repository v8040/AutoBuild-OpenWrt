#!/usr/bin/env bash

mkdir -p files/root

# Clone oh-my-zsh repository
git clone -q --depth=1 https://github.com/ohmyzsh/ohmyzsh.git files/root/.oh-my-zsh

# Install extra plugins
git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git files/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git files/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Get .zshrc dotfile
[[ -f "${GITHUB_WORKSPACE}/scripts/.zshrc" ]] && cp -f "${GITHUB_WORKSPACE}/scripts/.zshrc" files/root/.zshrc

printf '[ \e[32mSUCCESS\e[0m ] %s\n' "[${0##*/}] done"
exit 0