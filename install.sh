#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install ripgrep node llvm bat lua-language-server
fi

npm install -g typescript vscode-langservers-extracted
