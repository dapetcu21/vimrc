#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install neovim ripgrep fd llvm
fi
