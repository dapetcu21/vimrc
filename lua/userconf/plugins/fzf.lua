vim.g.fzf_glob = vim.g.fzf_glob or ""

local function set_glob()
  vim.ui.input({ prompt = 'Grep Filter Globs> ', default = vim.g.fzf_glob }, function (input)
    if input ~= nil then
      vim.g.fzf_glob = input
    end
  end)
end

local function grep_with_confirm(default_search)
  local glob = vim.g.fzf_glob or ""
  local prompt = ((glob == "") and "" or ("[" .. glob .. "] ")) .. "Grep For> "
  vim.ui.input({ prompt = prompt, default = default_search }, function (search)
    if search == nil then
      return
    end
    require('fzf-lua').grep({ search = (glob == "") and search or (search .. " -- " .. glob)})
  end)
end

local function grep()
  grep_with_confirm()
end

local function grep_visual()
  local utils = require "fzf-lua.utils"
  local search = utils.get_visual_selection()
  grep_with_confirm(search)
end

local function grep_cword()
  local utils = require "fzf-lua.utils"
  local search = utils.rg_escape(vim.fn.expand("<cword>"))
  grep_with_confirm(search)
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "call fzf#install()" },
      "nvim-tree/nvim-web-devicons",
    },

    cmd = { 'FzfLua' },
    keys = {
      { "<space>/", grep_visual, mode = 'v', silent = true },
      { "<space>/", grep_cword, mode = 'n', silent = true },
      { "<space>?", grep, mode = 'n', silent = true },
      { "<C-/>", set_glob, mode = 'n', silent = true },
      { "<space>z", "<Cmd>FzfLua<CR>", mode = 'n', silent = true },
      { "<space>Z", "<Cmd>FzfLua resume<CR>", mode = 'n', silent = true },
      { "<space>f", "<Cmd>FzfLua files<CR>", mode = 'n', silent = true },
      { "<space>F", "<Cmd>FzfLua oldfiles<CR>", mode = 'n', silent = true },
      { "<space>b", "<Cmd>FzfLua buffers<CR>", mode = 'n', silent = true },
      { "<space>q", "<Cmd>FzfLua quickfix<CR>", mode = 'n', silent = true },
    },

    config = function()
      require("fzf-lua").setup({
        grep = {
          rg_glob = true,
        },
      })
    end
  },
}
