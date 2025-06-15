local M = {}

local function get_count()
  local count = vim.v.count
  if count == 0 then
    return 1
  end
  return count
end

function M.setup()
  -- Disable LSP logging. We can enable it if we need it
  vim.lsp.set_log_level("off")

  -- Enable inlay hints
  vim.lsp.inlay_hint.enable(true)

  vim.lsp.config('clangd', {
    cmd = { 'clangd', '--header-insertion=never' }
  })

  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<leader>r', vim.diagnostic.open_float, { desc = 'Diagnostics: Open float' })
  vim.keymap.set('n', '<leader>rf', vim.diagnostic.open_float, { desc = 'Diagnostics: Open float' })
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -get_count() }) end, { desc = 'Diagnostics: Go to previous diagnostic' })
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = get_count() }) end, { desc = 'Diagnostics: Go to next diagnostic' })
  vim.keymap.set('n', '<leader>rl', vim.diagnostic.setloclist, { desc = 'Diagnostics: Set loclist' })
  vim.keymap.set('n', '<leader>mi', function () vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { silent = true, desc = "LSP: Toggle Inlay Hints" })

  local augroup = vim.api.nvim_create_augroup('UserLspConfig', {})

  vim.api.nvim_create_user_command('ToggleFormatOnWrite', function ()
    local setting = vim.g.Session_format_on_write
    setting = (setting == true or setting == 1)
    vim.g.Session_format_on_write = setting and 0 or 1
    vim.notify(setting and 'Format on write disabled' or 'Format on write enabled', vim.log.levels.INFO)
  end, { desc = 'Toggles LSP format on buffer write' })

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup,
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
      vim.keymap.set({'n', 'v'}, '<leader>=', function()
        vim.lsp.buf.format { async = true }
      end, opts('LSP: Auto-format'))
      vim.keymap.set({'n', 'v'}, '<leader>a', vim.lsp.buf.code_action, opts('LSP: Code actions'))

      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = ev.buf })

      if client:supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = ev.buf,
          callback = function()
            local setting = vim.g.Session_format_on_write
            if setting == true or setting == 1 then
              vim.lsp.buf.format({ async = false })
            end
          end,
        })
      end
    end,
  })
end

return M
