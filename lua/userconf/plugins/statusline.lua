return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function ()
      local filename_symbols = {
        modified = '',
        readonly = '󰌾',
        unnamed = '[No Name]',
        newfile = '[New]',
      }

      local symbols = require('trouble').statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal",
      })

      require('lualine').setup({
        extensions = { 'nvim-tree', 'nvim-dap-ui', 'quickfix' },
        options = {
          disabled_filetypes = { 'trouble', 'NvimTree' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'diff', 'diagnostics'},
          lualine_c = {
            { 'filename', newfile_status = true, symbols = filename_symbols }
          },
          lualine_x = {
            'encoding',
            {
              function () return 'BOM' end,
              cond = function ()
                local bufnr = vim.api.nvim_get_current_buf()
                return not not vim.bo[bufnr].bomb
              end,
            },
            'fileformat',
            'filetype'
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {{'filename', symbols = filename_symbols}},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {
          lualine_a = {
            {
              function ()
                local possession_status
                if package.loaded['nvim-possession'] ~= nil then
                  possession_status = require("nvim-possession").status()
                end
                if possession_status ~= nil then
                  return possession_status
                end
                return vim.fn.fnamemodify(vim.uv.cwd(), ':t')
              end
            },
          },
          lualine_b = {'branch'},
          lualine_c = {
            {
              'filetype',
              icon_only = true,
              separator = { left = '', right = '' },
              padding = { left = 1, right = 0 },
            },
            {
              'filename',
              path = 1,
              padding = { left = 0, right = 1 },
              shorting_target = 10,
              symbols = filename_symbols,
            },
            {
              symbols.get,
              cond = symbols.has,
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {'tabs'}
        }
      })
    end,
  },
}
