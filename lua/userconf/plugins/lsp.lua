return {
  {
    "mason-org/mason.nvim",

    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },

    opts = {}
  },

  {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
  },

  {
    "mason-org/mason-lspconfig.nvim",

    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    event = "VeryLazy",
    priority = -100,

    opts = {},
  },

  {
    "jay-babu/mason-null-ls.nvim",

    dependencies = {
      "williamboman/mason.nvim",
      {
        "nvimtools/none-ls.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
    },

    event = "VeryLazy",
    priority = -100,

    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {},
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
        }
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    'p00f/clangd_extensions.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    keys = {
      { "<leader>i", "<Cmd>ClangdSwitchSourceHeader<CR>", mode = "n", silent = true, desc = 'Clangd: Switch between header and source' },
    },
    cmd = {
      "ClangdSwitchSourceHeader",
      "ClangdAST",
      "ClangdSymbolInfo",
      "ClangdTypeHierarchy",
      "ClangdMemoryUsage",
    },
  },

  {
    'rhysd/vim-clang-format',
    cmd = { 'ClangFormat' },
    keys = {
      { '<leader>+', '<Cmd>ClangFormat<CR>', silent = true, desc = 'Clangd: Auto-format' },
    },
  },
}
