#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install ripgrep
fi

nvim +PlugInstall +qall
