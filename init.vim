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
set switchbuf=useopen,uselast
filetype indent on

" Infinite terminal scrollback
autocmd TermOpen * setlocal scrollback=-1

" Disable some Neovide animations
let g:neovide_cursor_trail_size = 0
let g:neovide_scroll_animation_far_lines = 0


"=== Load plugins and Lua init
lua require("userconf")

