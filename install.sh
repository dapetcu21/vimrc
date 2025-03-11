#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install ripgrep fd node llvm lua-language-server
fi

npm install -g typescript vscode-langservers-extracted
