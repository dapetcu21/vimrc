#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install ripgrep the_silver_searcher
fi

nvim +PlugInstall +qall
