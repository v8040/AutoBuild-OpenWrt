#!/bin/bash

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/aarch64_cortex-a53/kiddin9" >> package/system/opkg/files/customfeeds.conf

rm_package() {
    find ./ -maxdepth 4 -iname "$1" -type d | xargs rm -rf || echo -e "\e[31mNot found [$1]\e[0m"
}

rm_package "zerotier"

git_sparse_clone() {
    branch="$1" repourl="$2" repodir="$3"
    [[ -d "package/cache" ]] && rm -rf package/cache
    git clone -q --branch=$branch --depth=1 --filter=blob:none --sparse $repourl package/cache &&
    git -C package/cache sparse-checkout set $repodir &&
    mv -f package/cache/$repodir package &&
    rm -rf package/cache ||
    echo -e "\e[31mFailed to sparse clone $repodir from $repourl($branch).\e[0m"
}

git_sparse_clone main https://github.com/v8040/openwrt-packages.git zerotier

replace_text() {
  search_text="$1" new_text="$2"
  sed -i "s/$search_text/$new_text/g" $(grep "$search_text" -rl ./ 2>/dev/null) || echo -e "\e[31mNot found [$search_text]\e[0m"
}

replace_text "迷你DLNA" "DLNA"

echo -e "\e[32m$0 [DONE]\e[0m"