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
set tabstop=4
set shiftwidth=4
set smartindent

set makeprg=make\ %<\ LDLIBS=\"-lm\"\ CFLAGS=\"-Wall\ -O2\ -W\"\ CPPFLAGS=\"-Wall\ -O2\ -W\"

map 1 1<C-w>w
map 2 2<C-w>w
map 3 3<C-w>w
map 4 4<C-w>w
map 5 5<C-w>w
map 6 6<C-w>w
map 7 7<C-w>w
map 8 :w<CR>:make<CR>
map 9 :w<CR>:make<CR>:!clear<CR>:!time ./%<<CR>

command W w !sudo tee % > /dev/null

if has("unix")
    if system("echo -n \"$(uname)\"") == "Darwin"
        vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
        nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p
    else
        vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<Return><CR>
        nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
    endif
endif
imap <C-v> <Esc><C-v>a

set completeopt=menu,menuone,longest
set pumheight=15
let g:clang_complete_macros=1

if has("gui_running")
    nmap <C-Space> <C-Bslash>
    imap <C-Space> <C-Bslash>
elseif has("win32unix")
    nmap <C-@> <C-Bslash>
    imap <C-@> <C-Bslash>
else
    nmap <Nul> <C-Bslash>
    imap <Nul> <C-Bslash>
endif    

nmap <C-Bslash> i<C-x><C-u>
imap <C-Bslash> <C-x><C-u>

set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set mouse=a

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
