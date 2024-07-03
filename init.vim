"=== Startup settings
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
if $COLORTERM == 'truecolor' || has('gui_running')
  set termguicolors
  set pumblend=20
end

if has('gui_running')
  set guifont=FiraCode\ Nerd\ Font\ Mono:h11
end

set autoread "Reload files that changed on disk
set clipboard=unnamedplus
set mouse=a
set number
set nowrap
set cmdheight=1
set hidden
set updatetime=300
set signcolumn=number
set confirm
filetype indent on

" Ripgrep or The Silver Searcher
if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c:%m
endif

" Infinite terminal scrollback
autocmd TermOpen * setlocal scrollback=-1

" Disable some Neovide animations
let g:neovide_cursor_trail_size = 0
let g:neovide_scroll_animation_far_lines = 0

"=== Keybindings and command mappings
" Quick access to nohl
nnoremap <silent><nowait> <space>n  <Cmd>nohl<CR>

" Search visual selection or current word
vnoremap <silent> <leader>/ y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent> <leader>/ /\V<C-R>=expand('<cword>')<CR><CR>

" Quick access to edit this file
command! EditInit :execute "e " . stdpath("config") . "/init.vim"

" Git untracked grep (grep everywhere except .gitignore'd files)
command! -nargs=+ Gugrep :Ggrep -I --untracked <args>

" Exit terminal
tnoremap <silent><nowait> <leader><ESC> <C-\><C-n>


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
