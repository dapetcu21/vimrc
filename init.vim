"=== Startup settings
set encoding=utf-8

"Fix unicode clipboard issues
try
  lang en_US.UTF-8
catch /^Vim\%((\a\+)\)\=:E319/
  "lang is unsupported in this vim
endtry

if $COLORTERM == 'truecolor' || has('gui_running')
  set termguicolors
  set pumblend=20
end


"=== General settings
if has('gui_running')
  set guifont=FiraCode\ Nerd\ Font\ Mono:h11
end

set shm+=I "Disable intro screen
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
set foldcolumn=auto:9
filetype indent on

" Infinite terminal scrollback
autocmd TermOpen * setlocal scrollback=-1

" Disable some Neovide animations
let g:neovide_cursor_trail_size = 0
let g:neovide_scroll_animation_far_lines = 0


"=== Indentation
set expandtab shiftwidth=2 tabstop=2
au FileType make   if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif
au FileType c      if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif
au FileType cpp    if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif


"=== File types
au BufNewFile,BufRead *.script\|*.gui_script\|*.render_script\|*.editor_script\|*.lua_  setlocal filetype=lua
au BufNewFile,BufRead *.vsh\|*.fsh\|*.fp\|*.vp setlocal filetype=glsl
au BufNewFile,BufRead *.fui setlocal filetype=fuior


"=== Load plugins and Lua init
lua require("userconf")

