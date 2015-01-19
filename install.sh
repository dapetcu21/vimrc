#!/bin/bash

git submodule init
git submodule update

if [ -e ${HOME}/.vimrc ] || [ -e ${HOME}/.vim  ]; then
    BKP="${HOME}/vimbackup-`dd if=/dev/random bs=6 count=1 2>/dev/null | base64`"
    echo "You already have a vimrc. Moving the old one to ${BKP}"
    mkdir -p "${BKP}"
    if [ -e ${HOME}/.vimrc ]; then
        mv ${HOME}/.vimrc "${BKP}/"
    fi
    if [ -e ${HOME}/.vim ]; then
        mv ${HOME}/.vim "${BKP}/"
    fi
fi

ln -s ${PWD}/.vimrc ${HOME}/.vimrc
ln -s ${PWD}/.vim ${HOME}/.vim
if [ "$1" == "--with-clang" ]; then
    vim "+let g:installYCMWithClang=1" +SetUpPlugins +qall
else
    vim +SetUpPlugins +qall
fi
