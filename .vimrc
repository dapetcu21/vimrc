set nocompatible
set backspace=indent,eol,start
set autoindent
set ruler showcmd
set hls ic is
set showmatch
set bg=dark
set nowrap
syntax on
set number

set expandtab
set tabstop=2
set shiftwidth=2
set smartindent

set makeprg=make\ %<\ LDLIBS=\"-lm\"\ CFLAGS=\"-Wall\ -O2\ -W\"\ CPPFLAGS=\"-Wall\ -O2\ -W\"

map 2 :w<CR> 
map 7 :w<CR>:make<CR>
map 8 :w<CR>:make<CR>:!clear<CR>:!time ./%<<CR>
