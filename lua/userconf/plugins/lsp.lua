return {
  {
    'saghen/blink.cmp',
    version = 'v0.13.1',

    dependencies = 'rafamadriz/friendly-snippets',

    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },

      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true },
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
  },

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
    "pmizio/typescript-tools.nvim",
    ft = "typescript",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
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
