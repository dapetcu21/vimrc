return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require("dap")

      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/local/opt/llvm/bin/lldb-vscode',
        name = 'lldb'
      }
      dap.configurations.lldb = dap.configurations.lldb or {}
      dap.configurations.cpp = dap.configurations.lldb

      dap.listeners.after.event_initialized["dapui_config"] = function()
        require('dapui').open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require('dapui').close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require('dapui').close()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},

    keys = {
      { '<space>d', '<Cmd>DapLoadLaunchJSON<CR><Cmd>DapContinue<CR>', mode = 'n', silent = true, desc = 'DAP: Start/Continue debugging' },
    },

    config = function ()
      local dapui = require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.4 },
              { id = 'breakpoints', size = 0.1 },
              { id = 'stacks', size = 0.4 },
              { id = 'watches', size = 0.1 },
            },
            size = 45,
            position = "left", -- Can be "left" or "right"
          },
          {
            elements = {
              'repl'
            },
            size = 10,
            position = "bottom", -- Can be "bottom" or "top"
          },
        },
      })
    end,
  },
}
