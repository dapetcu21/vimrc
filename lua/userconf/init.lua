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

-- Load local configuration
require('userconf.util').require_if_exists('local')
