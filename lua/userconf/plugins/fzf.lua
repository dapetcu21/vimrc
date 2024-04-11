local function grep_with_confirm(default_search)
  vim.ui.input({ prompt = 'Grep For>', default = default_search }, function (search)
    if search == nil then
      return
    end
    require('fzf-lua').grep({ search = search })
  end)
end

local function grep_visual()
  local utils = require "fzf-lua.utils"
  local search = utils.get_visual_selection()
  grep_with_confirm(search)
end

local function grep_cword()
  local utils = require "fzf-lua.utils"
  local search = [[\b]] .. utils.rg_escape(vim.fn.expand("<cword>")) .. [[\b]]
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
      { "<space>?", "<Cmd>FzfLua grep<CR>", mode = 'n', silent = true },
      { "<space>z", "<Cmd>FzfLua<CR>", mode = 'n', silent = true },
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
