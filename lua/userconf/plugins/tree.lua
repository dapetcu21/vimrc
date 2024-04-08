return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    cmd = {
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeFocus",
      "NvimTreeHiTest",
      "NvimTreeResize",
      "NvimTreeToggle",
      "NvimTreeRefresh",
      "NvimTreeCollapse",
      "NvimTreeFindFile",
      "NvimTreeClipboard",
      "NvimTreeFindFileToggle",
      "NvimTreeCollapseKeepBuffers",
    },

    keys = {
      { '<space>e', '<Cmd>NvimTreeToggle<CR>', mode = 'n', silent = true },
      { '<leader>e', '<Cmd>NvimTreeFindFile<CR>', mode = 'n', silent = true },
    },

    init = function ()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,

    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        view = {
          width = 50,
        },
        filters = {
          git_ignored = false,
        },
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
        callback = function()
          local layout = vim.api.nvim_call_function("winlayout", {})
          if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
            vim.cmd("quit")
          end
        end
      })
    end,
  },
}
