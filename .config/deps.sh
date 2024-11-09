#!/usr/bin/env sh
set -eu

sudo apt install -y $(cat .config/apt.txt)

cargo install gitui --locked
