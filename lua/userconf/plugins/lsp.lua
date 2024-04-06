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

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<space>r', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>=', function()
            vim.lsp.buf.format { async = true }
          end, opts)
          vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<space>s', '<cmd>FzfLua lsp_document_symbols<cr>', opts)
          vim.keymap.set('n', '<space>S', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', opts)
        end,
      })
    end,
  },

  {
    'p00f/clangd_extensions.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    keys = {
      { "<space>i", "<Cmd>ClangdSwitchSourceHeader<CR>", mode = "n", silent = true },
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
      { '<space>=', '<Cmd>ClangFormat<CR>', silent = true },
    },
  },
}
