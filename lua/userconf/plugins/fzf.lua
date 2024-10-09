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
      { "<space>/", grep_visual, mode = 'v', silent = true, desc = 'Fzf: Grep visual selection' },
      { "<space>/", grep_cword, mode = 'n', silent = true, desc = 'Fzf: Grep word under cursor' },
      { "<space>?", grep, mode = 'n', silent = true, desc = 'Fzf: Grep' },
      { "<C-/>", set_glob, mode = 'n', silent = true, desc = 'Fzf: Set glob pattern' },
      { "<space>z", "<Cmd>FzfLua<CR>", mode = 'n', silent = true, desc = 'Fzf' },
      { "<space>Z", "<Cmd>FzfLua resume<CR>", mode = 'n', silent = true, desc = 'Fzf: Resume' },
      { "<space>f", "<Cmd>FzfLua files<CR>", mode = 'n', silent = true, desc = 'Fzf: Files' },
      { "<space>F", "<Cmd>FzfLua oldfiles<CR>", mode = 'n', silent = true, desc = 'Fzf: File history' },
      { "<space>b", "<Cmd>FzfLua buffers<CR>", mode = 'n', silent = true, desc = 'Fzf: Buffers' },
      { "<space>c", "<Cmd>FzfLua quickfix<CR>", mode = 'n', silent = true, desc = 'Fzf: Quickfix' },
      { "<space>l", "<Cmd>FzfLua loclist<CR>", mode = 'n', silent = true, desc = 'Fzf: Loclist' },
      { "<space>L", "<Cmd>FzfLua loclist_stack<CR>", mode = 'n', silent = true, desc = 'Fzf: Loclist stack' },
      { "<space>k", "<Cmd>FzfLua keymaps<CR>", mode = 'n', silent = true, desc = 'Fzf: Keymaps' },
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
