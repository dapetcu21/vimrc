"-- General editing settings
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
set smartindent
set guioptions-=r
set guioptions-=L
syntax on
set clipboard=unnamed
set visualbell
set background=dark
set shortmess=aO

"-- Installed plugins
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

"- Essentials
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'Open-associated-programs'
Bundle 'rking/ag.vim'
Bundle 'scrooloose/nerdcommenter'

"- Color scheme
Bundle 'chriskempson/base16-vim'

"- Git integration
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'

"- Filetype plugins
Bundle 'Nemo157/glsl.vim'
Bundle 'msanders/cocoa.vim'
Bundle 'DHowett/theos', { 'rtp': 'extras/vim/' }
Bundle 'elzr/vim-json'
Bundle 'kchmck/vim-coffee-script'
Bundle 'digitaltoad/vim-jade'
Bundle 'wavded/vim-stylus'

"-- Fallbacks for more basic systems
let g:installedCommandT = 0
let g:installedYCM = 0
let g:installedNPM = 0

if executable("npm")
    Bundle 'marijnh/tern_for_vim'
    let g:installedNPM = 1
    let g:nodejs = "nodejs"
    if !executable("nodejs")
        let g:nodejs = "node"
    endif
endif

if has("ruby")
    Bundle 'git://git.wincent.com/command-t.git'
    let g:installedCommandT = 1
endif

if ((v:version == 703 && has("patch584") ) || v:version > 703) && has("python")
    Bundle 'Valloric/YouCompleteMe'
    let g:installedYCM = 1
else
    function! TabOrComplete()
        if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
            return "\<C-N>"
        else
            return "\<Tab>"
        endif
    endfunction
    inoremap <Tab> <C-R>=TabOrComplete()<CR>
endif

filetype plugin indent on

"-- Indentation
set expandtab
set shiftwidth=4
set tabstop=4
au FileType *           setlocal expandtab   | setlocal tabstop=4 | setlocal shiftwidth=4
au FileType text        setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType lua         setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType cmake       setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType make        setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4

"- File types
au BufNewFile,BufRead *.xm\|*.xmm  setlocal filetype=logos
au BufNewFile,BufRead *.vsh\|*.fsh setlocal filetype=glsl

"- Webdev
au FileType coffee      setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType javascript  setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType json        setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType css         setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType html        setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType json        setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType stylus      setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType jade        setlocal expandtab   | setlocal tabstop=2 | setlocal shiftwidth=2


"-- For when you forget to run sudo vim
command! W w !sudo tee % > /dev/null

"-- Detect system type
let g:uname = system("echo -n \"$(uname)\"")

"-- System clipboard support for non-gui builds
"TODO: figure out how to move it from <C-v> because it conflicts
"with block select
if !has("gui")
    if has("unix")
        if g:uname == "Darwin"
            vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
            nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p
        else
            vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<Return><CR>
            nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
        endif
    endif
    imap <C-v> <Esc><C-v>a
endif

"-- Autocomplete
set completeopt=menu,menuone,longest
set pumheight=15
highlight Pmenu ctermfg=255
set updatetime=500
map <Leader>c :YcmForceCompileAndDiagnostics<CR>
let g:ycm_global_ycm_extra_conf = expand("$HOME") . "/.vim/ycm_global_conf.py"

if !has("gui_running")
    if has("win32unix")
        nmap <C-@> <C-Space>
        imap <C-@> <C-Space>
    else
        nmap <Nul> <C-Space>
        imap <Nul> <C-Space>
    endif
else
    colorscheme base16-default
endif

"-- NERDTree config
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <Leader>t :NERDTreeToggle<CR>

"-- Don't update GitGutter when changing focus. It slows down things
let g:gitgutter_all_on_focusgained = 0

"-- Ignores files
set wildignore+=*.o,*.obj,.git,*.dylib,*.a,*.so,node_modules

"-- Command-T key binds
map <C-p><C-p> :CommandT<CR>
map <C-p><C-o> :CommandTBuffer<CR>
map <C-p><C-r> :CommandTFlush<CR>

"-- Press F9 to compile and run stuff
function! MakeAndRun()
    w
    if !empty(matchstr(getline(1), "^#!")) || (&ft == "sh")
        silent !chmod +x "%:p"
        ! time "%:p"
    elseif &ft == "python"
        let mainpy = findfile("__main__.py", expand("%:p:h") . ";")
        if empty(mainpy)
            !python %
        else
            execute "!python " . fnamemodify(mainpy, ":p:h") 
        endif
    elseif &ft == "lua"
        !lua %
    elseif &ft == "javascript"
        execute "!" . g:nodejs . " %"
    elseif &ft == "vim"
        so %
    else
        let mkf = findfile("Makefile", expand("%:p:h") . ";")
        if empty(mkf)
            if &ft == "c"
                !cc -Wall -W -lm -g "%:p" -o "%:p:r" && time "%:p:r"
            elseif &ft == "cpp"
                !c++ -Wall -W -lm -g "%:p" -o "%:p:r" && time "%:p:r"
            elseif &ft == "java"
                !javac "%:p" && cd "%:p:h" && time java "%:t:r"
            endif
        else
            execute "! cd " . fnamemodify(mkf, ":p:h") . " && make -j8"
        endif
    endif
endfunction

command! MakeAndRun call MakeAndRun()
map <F9> :MakeAndRun<CR>

"-- Press F10 to show the assembly output of the current file
function! ShowAssembly()
    if &ft == "c" || &ft == "cpp"
        w
        if &ft == "c" 
            let compiler = "cc"
        else
            let compiler = "c++"
        end
        let fn = expand("%:p")

        " Use an existing "asm" window if it exists, otherwise open a new one.
        if &filetype != "asm"
            let thiswin = winnr()
            exe "norm! \<C-W>b"
            if winnr() > 1
                exe "norm! " . thiswin . "\<C-W>w"
                while 1
                    if &filetype == "asm"
                        break
                    endif
                    exe "norm! \<C-W>w"
                    if thiswin == winnr()
                        break
                    endif
                endwhile
            endif
            if &filetype != "asm"
              vnew
              wincmd L
              setl nonu fdc=0
            endif
        endif
        silent exec "edit $HOME/.vimasm~"
        " Avoid warning for editing the dummy file twice
        setl buftype=nofile noswapfile

        setl ma
        silent exec "norm 1GdG"
        silent execute "read !" . compiler . " -Wall -W -S \"" . fn . "\" -o -"
        setl ft=asm nomod
        setl bufhidden=hide
        setl nobuflisted
    endif
endfunction

command! ShowAssembly call ShowAssembly()
map <F10> :ShowAssembly<CR>

"-- Search the word under cursor on Google
function! Google(...)
    call xolox#open#url("http://google.com/search?q=" . join(map(copy(a:000), 'expand(v:val)'), "+"))
endfunction
command! -nargs=+ Google call Google(<f-args>)
map <Leader>g :Google <cword> <CR>

"-- Search the work under cursor through man pages
runtime ftplugin/man.vim
map K :Man <cword> <CR>

"-- Cycle through files of the same base name
let g:conjugate_paths="[expand('%:p:h')]"
function! CycleConjugates()
    let files = []
    let paths = eval(g:conjugate_paths)
    for path in paths
        let files = files + split(globpath(path, expand('%:t:r').'.*'), '\n')
    endfor
    let thisfile = expand("%:p")
    let pos = index(files, thisfile)
    if pos >= 0
        let pos = pos + 1
        if pos >= len(files)
            let pos = 0
        endif
        let newfile = files[pos]
        let win = bufwinnr(newfile)
        if win < 0
            if &mod
                execute 'vsplit ' . newfile
            else
                execute 'e ' . newfile
            endif
        else
            execute win . 'wincmd w'
        endif
    endif
endfunction
command! CycleConjugates call CycleConjugates()
map <Leader>j :CycleConjugates <CR>

"-- Installation scripts
function! InstallScriptCommandT()
    return "cd ~/.vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make"
endfunction

function! InstallScriptYCM()
    return "cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer"
endfunction

function! InstallScriptTern()
    return "cd ~/.vim/bundle/tern_for_vim && npm install"
endfunction


function! InstallCommandT()
    execute "!" . InstallScriptCommandT()
endfunction

function! InstallYCM()
    execute "!" . InstallScriptYCM()
endfunction

function! InstallTern()
    execute "!" . InstallScriptTern()
endfunction


function! SetUpPlugins()
    BundleInstall
    let cmd = "echo \"Installing external dependencies...\""
    if g:installedCommandT
        let cmd = cmd . " && " . InstallScriptCommandT()
    endif
    if g:installedNPM
        let cmd = cmd . " && " . InstallScriptTern()
    endif
    if g:installedYCM
        let cmd = cmd . " && " . InstallScriptYCM()
    endif
    execute "!" . cmd
endfunction
command! SetUpPlugins call SetUpPlugins()

"-- Locally customize this in ~/.vimrc.local 
"(The advantage being that .vimrc.local is not under version control)

if filereadable(glob("~/.vimrc.local")) 
    source ~/.vimrc.local
endif
