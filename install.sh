#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install ripgrep node llvm
fi

nvim +PlugInstall +qall
