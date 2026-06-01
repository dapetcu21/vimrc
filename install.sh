#!/bin/bash
set -e

if [ $(uname) == "Darwin" ]; then
  brew install neovim ripgrep fd llvm
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install neovim ripgrep fd-find llvm -y
fi
