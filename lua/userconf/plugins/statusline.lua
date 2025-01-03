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

      local function recording_status()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
          return ""
        else
          return "Recording @" .. recording_register
        end
      end

      local lualine = require('lualine')

      lualine.setup({
        extensions = { 'nvim-tree', 'nvim-dap-ui', 'quickfix' },
        options = {
          disabled_filetypes = { 'trouble', 'NvimTree' },
        },
        sections = {
          lualine_a = {'mode', recording_status },
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

      local augroup = vim.api.nvim_create_augroup('lualine_config', { clear = true })

      vim.api.nvim_create_autocmd("RecordingEnter", {
        group = augroup,
        callback = function()
          lualine.refresh({
            place = { "statusline" },
          })
        end,
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        group = augroup,
        callback = function()
          -- This is going to seem really weird!
          -- Instead of just calling refresh we need to wait a moment because of the nature of
          -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
          -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
          -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
          -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
          local timer = vim.loop.new_timer()
          timer:start(50, 0,
            vim.schedule_wrap(function()
              lualine.refresh({
                place = { "statusline" },
              })
            end)
          )
        end,
      })
    end,
  },
}
