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
    end,
  },
}
