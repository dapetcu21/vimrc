#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install ripgrep the_silver_searcher node llvm
fi

nvim +PlugInstall +qall
