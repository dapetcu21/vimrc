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
        use_nvim_cmp_as_default = true,
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
    'neovim/nvim-lspconfig',

    lazy = false,
    keys = {
      { "<leader>mi", function () vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, mode = 'n', silent = true, desc = "LSP: Toggle Inlay Hints" }
    },

    config = function ()
      local lsp = require "lspconfig"

      lsp.clangd.setup{}
      lsp.lua_ls.setup{}
      lsp.jsonls.setup{}

      -- Disable LSP logging. We can enable it if we need it
      vim.lsp.set_log_level("off")

      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<leader>r', vim.diagnostic.open_float, { desc = 'Diagnostics: Open float' })
      vim.keymap.set('n', '<leader>rf', vim.diagnostic.open_float, { desc = 'Diagnostics: Open float' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Diagnostics: Go to previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Diagnostics: Go to next diagnostic' })
      vim.keymap.set('n', '<leader>rl', vim.diagnostic.setloclist, { desc = 'Diagnostics: Set loclist' })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = function(desc) return { buffer = ev.buf, desc = desc } end
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('LSP: Hover'))
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('LSP: Signature help'))
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts('LSP: Add workspace folder'))
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts('LSP: Remove workspace folder'))
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts('LSP: List workspace folders'))
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts('LSP: Go to type definition'))
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts('LSP: Rename symbol'))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('LSP: Go to references'))
          vim.keymap.set('n', '<leader>=', function()
            vim.lsp.buf.format { async = true }
          end, opts('LSP: Auto-format'))
          vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts('LSP: Code actions'))
        end,
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
    "pmizio/typescript-tools.nvim",
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
