-- Leader key
vim.g.mapleader = " "

-- Load plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('userconf.plugins')

-- Copy path
local function copy_path(absolute)
  local path = vim.fs.normalize(vim.fn.expand(absolute and '%:p' or '%:.'));

  if vim.loop.os_uname().sysname:find('Windows') then
    path = path:gsub('/', '\\')
  end

  vim.fn.setreg('+', path)

  vim.notify(path, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('CopyPath', function () copy_path(false) end, {})
vim.api.nvim_create_user_command('CopyFullPath', function () copy_path(true) end, {})


-- Ripgrep or The Silver Searcher
if vim.fn.executable("rg") == 1 then
  vim.api.nvim_set_option_value("grepprg", "rg --vimgrep --smart-case --hidden", {})
  vim.api.nvim_set_option_value("grepformat", "%f:%l:%c:%m", {})
elseif vim.fn.executable("ag") == 1 then
  vim.api.nvim_set_option_value("grepprg", "ag --nogroup --nocolor --column", {})
  vim.api.nvim_set_option_value("grepformat", "%f:%l:%c:%m", {})
end

local function exec(cmd)
  require('toggleterm').exec(cmd)
end

vim.api.nvim_create_user_command('RgPrecache', function ()
  local precache_cmd = [[ rg JUST_PRECACHE_DONT_ACTUALLY_SEARCH_ANYTHING ]]
  if vim.loop.os_uname().sysname:find('Windows') then
    exec([[ Measure-Command { ]] .. precache_cmd .. [[ }]])
  else
    exec([[ time ]] .. precache_cmd)
  end
end, {})


-- Keybindings and command mappings
vim.api.nvim_set_keymap('n', '<leader>..', '<Cmd>nohl<CR>', { silent = true, desc = "Clear search highlighting (nohl)" })
vim.api.nvim_set_keymap('v', '<leader>./', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { silent = true, desc = "Search visual selection" })
vim.api.nvim_set_keymap('n', '<leader>./', [[/\V<C-R>=expand('<cword>')<CR><CR>]], { silent = true, desc = "Search word under cursor" })

vim.api.nvim_create_user_command('EditInit', ':execute "e " . stdpath("config") . "/init.vim"', {})
vim.api.nvim_create_user_command('Gugrep', ':Ggrep -I --untracked <args>', { nargs = "+" })


-- Show filename in title bar
vim.cmd([[
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
]])

-- Indentation
require("userconf.lsp").setup()

-- Indentation
require("userconf.indent").setup()

-- Load local configuration
require("userconf.local").setup()
