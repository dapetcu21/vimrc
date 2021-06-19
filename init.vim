"=== Plug plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Fast syntax highlighting
Plug 'nvim-treesitter/playground'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "VSCode-like extension host
Plug 'tpope/vim-fugitive' "Git integration
Plug 'tikhomirov/vim-glsl' "GLSL Syntax highlighting
Plug 'tpope/vim-commentary' "Toggle comments with gc<movement>
Plug 'morhetz/gruvbox' "Color theme
Plug 'altercation/vim-colors-solarized' "Color theme
Plug 'vim-airline/vim-airline' "Status line
Plug 'vim-airline/vim-airline-themes' "Status line themes
Plug 'tpope/vim-obsession' "Dependency for prosession
Plug 'dhruvasagar/vim-prosession' "Save window session on exit
Plug 'soywod/quicklist.vim' "Quicklist keyboard shortcuts
Plug 'yegappan/greplace' "Edit quicklist like a buffer
Plug 'bronson/vim-trailing-whitespace' "Show and fix trailing whitespace
Plug 'editorconfig/editorconfig-vim' "Respect .editor-config

call plug#end()


"=== coc extensions
let s:coc_ge = []
call add(s:coc_ge, 'coc-explorer') "File explorer sidebar
call add(s:coc_ge, 'coc-git') "Git integration
call add(s:coc_ge, 'coc-lists') "Extra fuzzy finder lists, like for switching files
call add(s:coc_ge, 'coc-tsserver') "TypeScript LSP
call add(s:coc_ge, 'coc-clangd') "C++ LSP
call add(s:coc_ge, 'coc-lua') "Lua LSP
call add(s:coc_ge, 'coc-json') "JSON LSP
call add(s:coc_ge, 'coc-yaml') "YAML LSP
call add(s:coc_ge, 'coc-prettier') "JS/TS code formatter
call add(s:coc_ge, 'coc-format-json') "JSON formatter
call add(s:coc_ge, 'coc-marketplace') "Coc extension marketplace
call add(s:coc_ge, 'coc-defold-ide') "Defold-related stuff
call add(s:coc_ge, 'coc-terminal') "Toggle terminal
let g:coc_global_extensions = s:coc_ge


"=== General settings
set encoding=utf-8
set autoread "Reload files that changed on disk
set termguicolors
set pumblend=20
set clipboard=unnamedplus
set mouse=a
set number
set nowrap
set cmdheight=1

" Load filetype plugins from ~/.config/nvim/ftplugins
filetype plugin indent on

" Search visual selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Quick access to edit this file
command! EditInit :e ~/.config/nvim/init.vim

" Git untracked grep (grep everywhere except .gitignore'd files)
command! Gugrep :Ggrep --untracked

"=== Indentation
set expandtab shiftwidth=2 tabstop=2
au FileType *      setlocal expandtab | setlocal tabstop=2 | setlocal shiftwidth=2
au FileType make   setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4


"=== File types
au BufNewFile,BufRead *.script\|*.gui_script\|*.render_script\|*.editor_script\|*.lua_  setlocal filetype=lua
au BufNewFile,BufRead *.vsh\|*.fsh\|*.fp\|*.vp setlocal filetype=glsl
au BufNewFile,BufRead *.fui setlocal filetype=fuior

"=== Tree-sitter
lua <<EOF
local parsers
local configs
local ok, err = pcall(function ()
  parsers = require "nvim-treesitter.parsers"
  configs = require "nvim-treesitter.configs"
end)
if not ok then return end

local parser_config = parsers.get_parser_configs()
parser_config.fuior = {
  install_info = {
    url = "https://github.com/critique-gaming/tree-sitter-fuior", -- local path or git repo
    branch = "main",
    files = {"src/parser.c"},
  },
}

configs.setup {
  ensure_installed = { parsers.maintained_parsers(), "fuior" },
  highlight = { enable = true },
  indent = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
}
EOF


"=== Plugin config
let g:airline_powerline_fonts = 1

let g:prosession_dir = stdpath('data') . '/prosession'

set sessionoptions-=options  " Don't save options
set sessionoptions-=buffers  " Don't save hidden buffers
set sessionoptions-=help     " Don't save help windows

command! -nargs=0 Prettier :CocCommand prettier.formatFile


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


"=== Color schemes

func! SetITermProfile(profile)
  if $TERM_PROGRAM == "iTerm.app" && !s:supress_profile_change
    new
    call setline(1, "\033]50;SetProfile=" . a:profile . "\007")
    write >> /dev/stdout
    q!
  endif
endfunction

func! DarkMode()
  let g:COLOR_SCHEME_MODE = "dark"
  set background=dark
  colorscheme gruvbox
  AirlineTheme gruvbox
  call SetITermProfile("Default")
endfunction

func! LightMode()
  let g:COLOR_SCHEME_MODE = "light"
  set background=light
  colorscheme solarized
  AirlineTheme solarized
  call SetITermProfile("Light")
endfunction

func! ToggleDarkMode()
  if g:COLOR_SCHEME_MODE == "dark"
    call LightMode()
  else
    call DarkMode()
  endif
endfunction

let s:supress_profile_change = 0
command! LightMode :call LightMode()
command! DarkMode :call DarkMode()
command! ToggleDarkMode :call ToggleDarkMode()

func s:DarkModeInit()
  let s:supress_profile_change = 1
  if exists("g:COLOR_SCHEME_MODE") && g:COLOR_SCHEME_MODE == "light"
    LightMode
  else
    DarkMode
  endif
  let s:supress_profile_change = 0
endfunction
au VimEnter * call s:DarkModeInit() "After ShaDa loaded


"=== Key maps
nnoremap <space>e :CocCommand explorer<CR>

nnoremap <space>h :CocCommand defold-ide.refactorHash<CR>
vnoremap <space>h :CocCommand defold-ide.refactorHashVisual<CR>

nmap <space>t <Plug>(coc-terminal-toggle)
tnoremap <leader><ESC> <C-\><C-n>

nmap <leader>c <plug>(quicklist-toggle-qf)
nmap <leader>l <plug>(quicklist-toggle-lc)
nnoremap <silent> <leader>gc :<C-u>Gqfopen<CR><C-W>L

"=== vim.coc config:

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>x  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Search files.
nnoremap <silent><nowait> <space>f  :<C-u>CocList files<cr>
" Search buffers.
nnoremap <silent><nowait> <space>b  :<C-u>CocList buffers<cr>
" Most recently used files
nnoremap <silent><nowait> <space>m  :<C-u>CocList mru<CR>
" Quickfix list
nnoremap <silent><nowait> <space>q  :<C-u>CocList quickfix<CR>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

