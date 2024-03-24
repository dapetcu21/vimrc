"=== Startup settings
let g:loaded_netrw = 1 " Disable the built-in directory browser. We use nvim-tree
let g:loaded_netrwPlugin = 1

set encoding=utf-8

"Fix unicode clipboard issues
try
  lang en_US.UTF-8
catch /^Vim\%((\a\+)\)\=:E319/
  "lang is unsupported in this vim
endtry

"=== Load plugins
lua require("userconf")

"=== General settings
set autoread "Reload files that changed on disk
if $COLORTERM == 'truecolor'
  set termguicolors
end
set pumblend=20
set clipboard=unnamedplus
set mouse=a
set number
set nowrap
set cmdheight=1
autocmd TermOpen * setlocal scrollback=-1
set hidden
set updatetime=300
set signcolumn=number

" Load filetype plugins from ~/.config/nvim/ftplugins
filetype plugin indent on

" Ripgrep or The Silver Searcher
if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c:%m
endif


"=== Keybindings and command mappings
" Quick access to nohl
nnoremap <silent><nowait> <space>n  :<C-u>nohl<CR>

" Search visual selection or current word
vnoremap <leader>/ y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <leader>/ /\V<C-R>=expand('<cword>')<CR><CR>

" Quick access to edit this file
command! EditInit :execute "e " . stdpath("config") . "/init.vim"

" Git untracked grep (grep everywhere except .gitignore'd files)
command! -nargs=+ Gugrep :Ggrep -I --untracked <args>

" Clang Format
nnoremap <space>= :ClangFormat<CR>

" Terminal
nmap <silent><nowait> <space>t <Plug>(coc-terminal-toggle)
tnoremap <silent><nowait> <leader><ESC> <C-\><C-n>

" Quicklist
nmap <silent><nowait> <leader>c <plug>(quicklist-toggle-qf)
nmap <silent><nowait> <leader>l <plug>(quicklist-toggle-lc)
nnoremap <silent> <leader>gc :<C-u>Gqfopen<CR><C-W>L

" Global search selection or word under cursor
vnoremap <silent><nowait> <space>/ :<C-u>FzfLua grep_visual<CR>
nnoremap <silent><nowait> <space>/ :<C-u>FzfLua grep_cword<CR>

nnoremap <silent><nowait> <space>z  :<C-u>FzfLua<cr>
nnoremap <silent><nowait> <space>f  :<C-u>FzfLua files<cr>
nnoremap <silent><nowait> <space>F  :<C-u>FzfLua oldfiles<cr>
nnoremap <silent><nowait> <space>b  :<C-u>FzfLua buffers<cr>
nnoremap <silent><nowait> <space>q  :<C-u>FzfLua quickfix<CR>

nnoremap <silent><nowait> <space>e :<C-u>NvimTreeToggle<CR>
nnoremap <silent><nowait> <leader>e :<C-u>NvimTreeFindFile<CR>

nnoremap <silent><nowait> <space>i :<C-u>ClangdSwitchSourceHeader<CR>

nnoremap <silent><nowait> <space>d :DapLoadLaunchJSON<CR>:DapContinue<CR>

"=== Indentation
set expandtab shiftwidth=2 tabstop=2
au FileType *      if get(b:, 'editorconfig_applied', 0) != 1 | setlocal expandtab | setlocal tabstop=2 | setlocal shiftwidth=2 | endif
au FileType make   if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif
au FileType c      if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif
au FileType cpp    if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif


"=== File types
au BufNewFile,BufRead *.script\|*.gui_script\|*.render_script\|*.editor_script\|*.lua_  setlocal filetype=lua
au BufNewFile,BufRead *.vsh\|*.fsh\|*.fp\|*.vp setlocal filetype=glsl
au BufNewFile,BufRead *.fui setlocal filetype=fuior


"=== Plugin config
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:show_spaces_that_precede_tabs=1
let g:better_whitespace_filetypes_blacklist=['NvimTree', 'fugitive', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown']

function! TryWincmdL()
	try
		wincmd L
	catch /.*/
	endtry
endfunction
autocmd User FugitiveIndex silent call TryWincmdL()

function! ToggleGStatus()
    if buflisted(bufname('.git//'))
        bd .git//
    else
        G
    endif
endfunction
command ToggleGStatus :call ToggleGStatus()

map <silent><nowait> <space>g :ToggleGStatus<CR>


"=== Show filename in title bar

if has("gui") || $TERM =~ '^\(screen\|xterm\)'
  function! s:abbreviate_filename(fname, maxlen)
    let l:short_name = strpart(a:fname, strlen(a:fname) - a:maxlen)
    if short_name != a:fname
      let l:short_name = "..." . short_name
    end
    return l:short_name
  endfunction

  function! UpdateTitle()
    let l:pwd = s:abbreviate_filename(fnamemodify(getcwd(), ":~"), 30)
    let l:fname = fnamemodify(expand("%"), ":.")
    let l:hfname = fnamemodify(expand("%"), ":~")
    if strlen(hfname) < strlen(fname)
      let l:fname = hfname
    end
    let l:fname = s:abbreviate_filename(fname, 30)
    let &titlestring = "[" . pwd . "] " . fname
  endfunction

  autocmd WinEnter * call UpdateTitle()
  autocmd BufEnter * call UpdateTitle()

  if $TERM == "screen"
    set t_ts=^[k
    set t_fs=^[\
  endif
  call UpdateTitle()
  set title
endif


"=== Local config

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
call SourceIfExists(stdpath('config') . '/local_init.vim')
