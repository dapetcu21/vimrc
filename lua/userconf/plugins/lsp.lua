return {
  {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    build = ':COQdeps',
    init = function ()
      vim.g.coq_settings = { auto_start = 'shut-up' }
    end,
  },

  {
    'ms-jpq/coq.artifacts',
    branch = 'artifacts',
    dependencies = { 'ms-jpq/coq_nvim' }
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = { 'ms-jpq/coq_nvim' },
    config = function ()
      local lsp = require "lspconfig"
      local coq = require "coq"

      lsp.clangd.setup(coq.lsp_ensure_capabilities({
        on_attach = function ()
          require("clangd_extensions.inlay_hints").setup_autocmd()
          require("clangd_extensions.inlay_hints").set_inlay_hints()
        end,
      }))

      lsp.lua_ls.setup(coq.lsp_ensure_capabilities({}))

      --Enable (broadcasting) snippet capability for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lsp.jsonls.setup(coq.lsp_ensure_capabilities({
        capabilities = capabilities,
      }))

      -- Disable LSP logging. We can enable it if we need it
      vim.lsp.set_log_level("off")

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<space>r', vim.diagnostic.open_float, { desc = 'Diagnostics: Open float' })
      vim.keymap.set('n', '<space>rf', vim.diagnostic.open_float, { desc = 'Diagnostics: Open float' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Diagnostics: Go to previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Diagnostics: Go to next diagnostic' })
      vim.keymap.set('n', '<space>rl', vim.diagnostic.setloclist, { desc = 'Diagnostics: Set loclist' })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = function(desc) return { buffer = ev.buf, desc = desc } end
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('LSP: Go to declaration'))
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('LSP: Go to definition'))
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('LSP: Hover'))
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('LSP: Go to implementation'))
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('LSP: Signature help'))
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts('LSP: Add workspace folder'))
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts('LSP: Remove workspace folder'))
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts('LSP: List workspace folders'))
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts('LSP: Go to type definition'))
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts('LSP: Rename symbol'))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('LSP: Go to references'))
          vim.keymap.set('n', '<leader>=', function()
            vim.lsp.buf.format { async = true }
          end, opts('LSP: Auto-format'))
          vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, opts('LSP: Code actions'))
          vim.keymap.set('n', '<space>s', '<cmd>FzfLua lsp_document_symbols<cr>', opts('Fzf: LSP document symbols'))
          vim.keymap.set('n', '<space>S', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', opts('Fzf: LSP workspace symbols'))
        end,
      })
    end,
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
      { "<space>i", "<Cmd>ClangdSwitchSourceHeader<CR>", mode = "n", silent = true, desc = 'Clangd: Switch between header and source' },
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
      { '<space>=', '<Cmd>ClangFormat<CR>', silent = true, desc = 'Clangd: Auto-format' },
    },
  },
}
