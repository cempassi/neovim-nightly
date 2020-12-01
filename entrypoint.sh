#!/bin/sh
set -e

echo -e "\n Setting up plugins"
su neovim -c 'nvim --headless +PackerCompile +PackerSync +qa'
su neovim -c 'nvim'
