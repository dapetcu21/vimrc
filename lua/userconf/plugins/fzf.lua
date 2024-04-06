return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "call fzf#install()" },
      "nvim-tree/nvim-web-devicons",
    },

    cmd = { 'FzfLua' },
    keys = {
      { "<space>/", "<Cmd>FzfLua grep_visual<CR>", mode = 'v', silent = true },
      { "<space>/", "<Cmd>FzfLua grep_cword<CR>", mode = 'n', silent = true },
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
