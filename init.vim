"=== Plug plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Fast syntax highlighting
Plug 'nvim-treesitter/playground'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "VSCode-like extension host
Plug 'tpope/vim-fugitive' "Git integration
Plug 'tikhomirov/vim-glsl' "GLSL Syntax highlighting
Plug 'tpope/vim-commentary' "Toggle comments with gc<movement>
Plug 'morhetz/gruvbox' "Color theme
Plug 'sainnhe/gruvbox-material' "Color theme
Plug 'vim-airline/vim-airline' "Status line
Plug 'vim-airline/vim-airline-themes' "Status line themes
Plug 'tpope/vim-obsession' "Dependency for prosession
Plug 'dhruvasagar/vim-prosession' "Save window session on exit
Plug 'soywod/quicklist.vim' "Quicklist keyboard shortcuts
Plug 'yegappan/greplace' "Edit quicklist like a buffer
Plug 'ntpeters/vim-better-whitespace' "Show and fix trailing whitespace
Plug 'editorconfig/editorconfig-vim' "Respect .editor-config
Plug 'ap/vim-css-color' "CSS color highlighting
Plug 'rhysd/vim-clang-format' "C++ auto-indenting
Plug 'ii14/exrc.vim' "Ask to run .exrc
Plug 'mfussenegger/nvim-dap' "Debug adapter protocol
Plug 'rcarriga/nvim-dap-ui' "DAP UI

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
call SourceIfExists(stdpath('config') . '/local_plugins.vim')

call plug#end()


"=== coc extensions
let s:coc_ge = []
call add(s:coc_ge, 'coc-git') "Git integration
call add(s:coc_ge, 'coc-lists') "Extra fuzzy finder lists, like for switching files
call add(s:coc_ge, 'coc-tsserver') "TypeScript LSP
call add(s:coc_ge, 'coc-clangd') "C++ LSP
call add(s:coc_ge, 'coc-lua') "Lua LSP
call add(s:coc_ge, 'coc-json') "JSON LSP
call add(s:coc_ge, 'coc-yaml') "YAML LSP
call add(s:coc_ge, 'coc-prettier') "JS/TS code formatter
call add(s:coc_ge, 'coc-eslint') "JS/TS code linter
call add(s:coc_ge, 'coc-format-json') "JSON formatter
call add(s:coc_ge, 'coc-marketplace') "Coc extension marketplace
call add(s:coc_ge, 'coc-defold-ide') "Defold-related stuff
call add(s:coc_ge, 'coc-terminal') "Toggle terminal
call add(s:coc_ge, 'coc-fuior') "Fuior linting and hot reload
let g:coc_global_extensions = s:coc_ge


"=== General settings
set encoding=utf-8
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
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

"Fix unicode clipboard issues
try
  lang en_US.UTF-8
catch /^Vim\%((\a\+)\)\=:E319/
  "lang is unsupported in this vim
endtry

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
nnoremap <silent><nowait> <space>b  :<C-u>FzfLua buffers<cr>
nnoremap <silent><nowait> <space>q  :<C-u>FzfLua quickfix<CR>

nnoremap <silent><nowait> <space>e :<C-u>NvimTreeToggle<CR>
nnoremap <silent><nowait> <leader>e :<C-u>NvimTreeFindFile<CR>

"=== Indentation
set expandtab shiftwidth=2 tabstop=2
au FileType *      if get(b:, 'editorconfig_applied', 0) != 1 | setlocal expandtab | setlocal tabstop=2 | setlocal shiftwidth=2 | endif
au FileType make   if get(b:, 'editorconfig_applied', 0) != 1 | setlocal noexpandtab | setlocal tabstop=4 | setlocal shiftwidth=4 | endif


"=== File types
au BufNewFile,BufRead *.script\|*.gui_script\|*.render_script\|*.editor_script\|*.lua_  setlocal filetype=lua
au BufNewFile,BufRead *.vsh\|*.fsh\|*.fp\|*.vp setlocal filetype=glsl
au BufNewFile,BufRead *.fui setlocal filetype=fuior


"=== Plugin config
let g:airline_powerline_fonts = 1

let g:prosession_dir = stdpath('data') . '/prosession'
let g:Prosession_ignore_expr = {-> !isdirectory('.git')} " Only save sessions in git repos

set sessionoptions-=options  " Don't save options
set sessionoptions-=buffers  " Don't save hidden buffers
set sessionoptions-=terminal " Don't save terminals
set sessionoptions-=help     " Don't save help windows

command! -nargs=0 Prettier :CocCommand prettier.formatFile

map <silent><nowait> <space>i :CocCommand clangd.switchSourceHeader<CR>
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

lua << EOF
require("nvim-tree").setup()
EOF


"=== DAP
lua << EOF
local dap = require("dap")
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/local/opt/llvm/bin/lldb-vscode',
  name = 'lldb'
}
dap.configurations.lldb = dap.configurations.lldb or {}
dap.configurations.cpp = dap.configurations.lldb

local dapui = require("dapui")

dapui.setup({
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.4 },
        { id = 'breakpoints', size = 0.1 },
        { id = 'stacks', size = 0.4 },
        { id = 'watches', size = 0.1 },
      },
      size = 45,
      position = "left", -- Can be "left" or "right"
    },
    {
      elements = {
        'repl'
      },
      size = 10,
      position = "bottom", -- Can be "bottom" or "top"
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

EOF

nnoremap <silent> <space>d :DapLoadLaunchJSON<CR>:DapContinue<CR>


"=== Tree-sitter
lua <<EOF
local parsers
local configs
local install
local ok, err = pcall(function ()
  parsers = require "nvim-treesitter.parsers"
  configs = require "nvim-treesitter.configs"
  install = require "nvim-treesitter.install"
end)
if not ok then return end

local is_windows = vim.loop.os_uname().sysname:find("Windows") and true or false
if is_windows then
  table.insert(install.compilers, "C:\\Program Files\\LLVM\\bin\\clang.exe")
  install.prefer_git = false
end

local parser_config = parsers.get_parser_configs()
parser_config.fuior = {
  install_info = {
    url = "https://github.com/critique-gaming/tree-sitter-fuior", -- local path or git repo
    branch = "main",
    files = {"src/parser.c"},
  },
}

local parser_list = parsers.available_parsers()
table.insert(parser_list, "fuior")

-- Astro doesn't compile on Windows
if is_windows then
  for i, v in ipairs(parser_list) do
    if v == "astro" then
      table.remove(parser_list, i)
      break
    end
  end
end

configs.setup {
  ensure_installed = parser_list,
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
  colorscheme gruvbox-material
  AirlineTheme gruvbox_material
  highlight ExtraWhitespace ctermbg=9 guibg=#FF0000
  call SetITermProfile("Default")
endfunction

func! LightMode()
  let g:COLOR_SCHEME_MODE = "light"
  set background=light
  colorscheme gruvbox-material
  highlight ExtraWhitespace ctermbg=9 guibg=#FF0000
  AirlineTheme gruvbox_material
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
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
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

" Mappings for CoCList and Fzf
" All Fzf providers.
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
" Most recently used files
nnoremap <silent><nowait> <space>m  :<C-u>CocList mru<CR>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

nnoremap <space>h :CocCommand defold-ide.refactorHash<CR>
vnoremap <space>h :CocCommand defold-ide.refactorHashVisual<CR>

call SourceIfExists(stdpath('config') . '/local_init.vim')
