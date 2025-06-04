return {
  {
    "mfussenegger/nvim-dap",

    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
    },

    cmd = {
      "DapContinue",
      "DapDisconnect",
      "DapNew",
      "DapTerminate",
      "DapRestartFrame",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapPause",
      "DapEval",
      "DapToggleRepl",
      "DapClearBreakpoints",
      "DapToggleBreakpoint",
      "DapSetLogLevel",
      "DapShowLog",
    },

    config = function()
      vim.cmd("hi DapBreakpointColor guifg=#fa4848")
      vim.cmd("hi DapStoppedColor guifg=#cbfa48")
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedColor" });
    end
  },

  {
    "jay-babu/mason-nvim-dap.nvim",

    lazy = true,

    opts = {
      automatic_installation = true,
      handlers = {
        function(config)
          local function persistent_input(key, skip_if_set, prompt, default, ...)
            local session_key = "Session_" .. key
            local stored = vim.g[session_key]

            if skip_if_set and stored ~= nil then
              return stored
            end

            default = stored or default

            local result = vim.fn.input(prompt, default, ...)
            if result ~= nil then
              vim.g[session_key] = result
            end

            return result
          end

          if config.name == "codelldb" then
            local function get_program(skip_if_set)
              return function ()
                return persistent_input("codelldb_program", skip_if_set, "Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end
            end

            local function get_args(skip_if_set)
              return function ()
                return vim.split(persistent_input("codelldb_args", skip_if_set, "Args: ", "") or "", " +", { trimempty = true })
              end
            end

            config.configurations[1].program = get_program(false)
            config.configurations[2].program = get_program(false)
            config.configurations[2].args = get_args(false)

            table.insert(config.configurations, 1, {
              name = 'LLDB: Launch last program',
              type = 'codelldb',
              request = 'launch',
              program = get_program(true),
              cwd = '${workspaceFolder}',
              stopOnEntry = false,
              args = get_args(true),
              console = 'integratedTerminal',
            })

            table.insert(config.configurations, {
              name = 'LLDB: Attach to process',
              type = 'codelldb',
              request = 'attach',
              cwd = '${workspaceFolder}',
              pid = function ()
                return require('dap.utils').pick_process()
              end,
              stopOnEntry = false,
              console = 'integratedTerminal',
            })
          end

          require("mason-nvim-dap").default_setup(config)
        end,
      },
    }
  },

  {
    "rcarriga/nvim-dap-ui",

    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text"
    },

    keys = {
      { "<F5>", "<Cmd>DapContinue<CR>", mode = "n", silent = true, desc = "DAP: Start/Continue debugging" },
      { "<F9>", "<Cmd>DapToggleBreakpoint<CR>", mode = "n", silent = true, desc = "DAP: Toggle breakpoint" },
      { "<F11>", "<Cmd>DapStepInto<CR>", mode = "n", silent = true, desc = "DAP: Step into" },
      { "<S-F11>", "<Cmd>DapStepOut<CR>", mode = "n", silent = true, desc = "DAP: Step out" },
      { "<F10>", "<Cmd>DapStepOver<CR>", mode = "n", silent = true, desc = "DAP: Step over" },
    },

    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end
  },
}
