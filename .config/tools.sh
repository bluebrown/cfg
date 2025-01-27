#!/usr/bin/env sh

curl -LO https://github.com/starship/starship/releases/download/v1.21.1/starship-x86_64-unknown-linux-gnu.tar.gz
curl -LO https://github.com/starship/starship/releases/download/v1.21.1/starship-x86_64-unknown-linux-gnu.tar.gz.sha256
echo "$(cat starship-x86_64-unknown-linux-gnu.tar.gz.sha256) starship-x86_64-unknown-linux-gnu.tar.gz" | sha256sum -c
tar -xzf starship-x86_64-unknown-linux-gnu.tar.gz -C "$HOME/.local/" starship

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz.sha256sum
sha256sum -c nvim-linux64.tar.gz.sha256sum
tar --strip-components 1 -C "$HOME/.local/" -xzf nvim-linux64.tar.gz

npm config set prefix=~/.local
npm i -g neovim

sudo apt install python3-neovim

# cd ~/.local/share/nvim/site/pack/deps/opt/LuaSnip/ || exit 1
# make install_jsregexp
