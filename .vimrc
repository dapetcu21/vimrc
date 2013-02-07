set nocompatible
set backspace=indent,eol,start
set autoindent
set ruler showcmd
set hls ic is
set showmatch
set bg=dark
set number
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set mouse=a
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
syntax on

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/nerdtree'
Bundle 'embear/vim-localvimrc'
Bundle 'msanders/cocoa.vim'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'DHowett/theos', { 'rtp': 'extras/vim/' }
filetype plugin indent on

au FileType python  set expandtab   | set tabstop=2 | set shiftwidth=2
au FileType lua     set expandtab   | set tabstop=2 | set shiftwidth=2
au FileType cmake   set expandtab   | set tabstop=2 | set shiftwidth=2
au FileType make    set noexpandtab | set tabstop=4 | set shiftwidth=4
au FileType cpp     set expandtab   | set tabstop=4 | set shiftwidth=4
au FileType c       set expandtab   | set tabstop=4 | set shiftwidth=4
au FileType objc    set expandtab   | set tabstop=4 | set shiftwidth=4
au FileType objcpp  set expandtab   | set tabstop=4 | set shiftwidth=4

au BufNewFile,BufRead *.xm  set filetype=logos
au BufNewFile,BufRead *.xmm set filetype=logos

set makeprg=make\ %<\ LDLIBS=\"-lm\"\ CFLAGS=\"-Wall\ -O2\ -W\"\ CPPFLAGS=\"-Wall\ -O2\ -W\"

map <F1> 1<C-w>w
map <F2> 2<C-w>w
map <F3> 3<C-w>w
map <F4> 4<C-w>w
map <F5> 5<C-w>w
map <F6> 6<C-w>w
map <F7> 7<C-w>w
map <F8> :w<CR>:make<CR>
map <F9> :w<CR>:make<CR>:!clear<CR>:!time ./%<<CR>

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
highlight Pmenu ctermfg=255

if !has("gui_running")
    if has("win32unix")
        nmap <C-@> <C-Space>
        imap <C-@> <C-Space>
    else
        nmap <Nul> <C-Space>
        imap <Nul> <C-Space>
    endif
else
    colorscheme Tomorrow-Night
endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
autocmd VimEnter * if !argc() | NERDTree | wincmd l | endif

set wildignore+=*.o,*.obj,.git,*build*,*.dylib,*.a
map <C-p><C-p> :CommandT<CR>
map <C-p><C-o> :CommandTBuffer<CR>
map <C-p><C-r> :CommandTFlush<CR>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

imap <C-h> <left>
imap <C-j> <down>
imap <C-k> <up>
imap <C-l> <right>
imap <C-o> <Return>

