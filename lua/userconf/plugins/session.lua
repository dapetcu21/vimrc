return {
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = { "ibhagwan/fzf-lua" },

    keys = {
      { '<space>sl', function () require('nvim-possession').list() end, mode = 'n', silent = true },
      { '<space>sn', function () require('nvim-possession').new() end, mode = 'n', silent = true },
      { '<space>su', function () require('nvim-possession').update() end, mode = 'n', silent = true },
      { '<space>sd', function () require('nvim-possession').delete() end, mode = 'n', silent = true },
    },
    lazy = false,

    config = {
      autoload = true,
      autoswitch = {
        enable = true,
      },
      save_hook = function()
        local buflist = vim.api.nvim_list_bufs()
        for _, bufnr in ipairs(buflist) do
          local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
          if ft == 'fugitive' or ft == 'NvimTree' or ft == 'toggleterm' then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end
      end
    },

    build = function()
      local sessions_path = vim.fn.stdpath("data") .. "/sessions"
      if vim.fn.isdirectory(sessions_path) == 0 then
        vim.uv.fs_mkdir(sessions_path, 511) -- 0777
      end
    end,

    init = function()
      vim.opt.sessionoptions:remove('options')  -- Don't save options
      vim.opt.sessionoptions:remove('buffers')  -- Don't save hidden buffers
      vim.opt.sessionoptions:remove('terminal') -- Don't save terminals
      vim.opt.sessionoptions:remove('help')     -- Don't save help windows
    end
  },
}
