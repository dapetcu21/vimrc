local sessions_path = vim.fn.stdpath("state") .. "/sessions"

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",

    keys = {
      { '<leader>po', function () require('persistence').load() end, mode = 'n', silent = true, desc = 'Sessions: Load from current dir' },
      { '<leader>pO', function () require('persistence').load({ last = true }) end, mode = 'n', silent = true, desc = 'Sessions: Load last session' },
      { '<leader>pl', function () require('persistence').select() end, mode = 'n', silent = true, desc = 'Sessions: Select session to load' },
      { '<leader>ps', function () require('persistence').stop() end, mode = 'n', silent = true, desc = 'Sessions: Stop' },
    },

    config = function ()
      vim.opt.sessionoptions:remove('options')  -- Don't save options
      vim.opt.sessionoptions:remove('buffers')  -- Don't save hidden buffers
      vim.opt.sessionoptions:remove('terminal') -- Don't save terminals
      vim.opt.sessionoptions:remove('help')     -- Don't save help windows
      vim.opt.sessionoptions:remove('blank')    -- Don't save utility windows
      vim.opt.sessionoptions:append('globals')  -- Save globals that start with Uppercase

      require('persistence').setup({
        dir = sessions_path .. "/",
      })

      local augroup = vim.api.nvim_create_augroup('persistence_config', { clear = true })

      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceSavePre",
        group = augroup,
        callback = function()
          local buflist = vim.api.nvim_list_bufs()
          for _, bufnr in ipairs(buflist) do
            local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
            if ft == 'fugitive' or ft == 'NvimTree' or ft == 'toggleterm' or ft == 'qf' or ft == 'trouble' or ft == 'snacks_picker_list' then
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end
          end
        end,
      })
    end,

    build = function()
      if vim.fn.isdirectory(sessions_path) == 0 then
        vim.uv.fs_mkdir(sessions_path, 511) -- 0777
      end
    end,
  },
}
