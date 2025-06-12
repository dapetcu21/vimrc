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

local function make_get_program(persistence_key)
  return function (skip_if_set)
    return function ()
      return persistent_input(persistence_key, skip_if_set, "Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end
  end
end

local function make_get_args(persistence_key)
  return function (skip_if_set)
    return function ()
      return vim.split(persistent_input(persistence_key, skip_if_set, "Args: ", "") or "", " +", { trimempty = true })
    end
  end
end

local function pick_process()
  return require('dap.utils').pick_process()
end

local function add_vsdbg_configs()
  local get_program = make_get_program("cppvsdbg_program")
  local get_args = make_get_args("cppvsdbg_args")

  local dap = require("dap")

  if dap.adapters.cppvsdbg ~= nil then
    local configs = {
      {
        name = 'VSDBG: Launch last program',
        type = 'cppvsdbg',
        request = 'launch',
        program = get_program(true),
        cwd = '${workspaceFolder}',
        args = get_args(true),
      },
      {
        name = 'VSDBG: Launch',
        type = 'cppvsdbg',
        request = 'launch',
        program = get_program(false),
        cwd = '${workspaceFolder}',
        args = {},
      },
      {
        name = 'VSDBG: Launch (args)',
        type = 'cppvsdbg',
        request = 'launch',
        program = get_program(false),
        cwd = '${workspaceFolder}',
        args = get_args(false),
      },
      {
        name = 'VSDBG: Attach to process',
        type = 'cppvsdbg',
        request = 'attach',
        cwd = '${workspaceFolder}',
        processId = pick_process
      },
    }

    dap.configurations.c = vim.list_extend(dap.configurations.c or {}, configs)
    dap.configurations.cpp = vim.list_extend(dap.configurations.cpp or {}, configs)
  end
end

local function add_nlua_configs()
  local dap = require("dap")

  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
    }
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
  end
end

return {
  {
    "mfussenegger/nvim-dap",

    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      { "dapetcu21/nvim-vsdbg", opts = {} },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      "igorlfs/nvim-dap-view",
      "rcarriga/nvim-dap-ui",
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

    keys = {
      { "<leader>dc", "<Cmd>DapContinue<CR>", mode = "n", silent = true, desc = "DAP: Start/Continue debugging" },
      { "<leader>dn", "<Cmd>DapNew<CR>", mode = "n", silent = true, desc = "DAP: New session" },
      { "<leader>dx", "<Cmd>DapDisconnect<CR>", mode = "n", silent = true, desc = "DAP: Disconnect" },
      { "<leader>dX", "<Cmd>DapTerminate<CR>", mode = "n", silent = true, desc = "DAP: Terminate" },
      { "<leader>db", "<Cmd>DapToggleBreakpoint<CR>", mode = "n", silent = true, desc = "DAP: Toggle breakpoint" },
      { "<leader>ds", "<Cmd>DapStepOver<CR>", mode = "n", silent = true, desc = "DAP: Step over" },
      { "<leader>di", "<Cmd>DapStepInto<CR>", mode = "n", silent = true, desc = "DAP: Step into" },
      { "<leader>do", "<Cmd>DapStepOut<CR>", mode = "n", silent = true, desc = "DAP: Step out" },

      { "<F5>", "<Cmd>DapContinue<CR>", mode = "n", silent = true, desc = "DAP: Start/Continue debugging" },
      { "<F9>", "<Cmd>DapToggleBreakpoint<CR>", mode = "n", silent = true, desc = "DAP: Toggle breakpoint" },
      { "<F10>", "<Cmd>DapStepOver<CR>", mode = "n", silent = true, desc = "DAP: Step over" },
      { "<F11>", "<Cmd>DapStepInto<CR>", mode = "n", silent = true, desc = "DAP: Step into" },
      { "<S-F11>", "<Cmd>DapStepOut<CR>", mode = "n", silent = true, desc = "DAP: Step out" },
    },

    config = function()
      local dap = require('dap')
      dap.defaults.fallback.switchbuf = "usevisible,useopen,uselast"

      vim.cmd("hi DapBreakpointColor guifg=#fa4848")
      vim.cmd("hi DapStoppedColor guifg=#cbfa48")
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapBreakpointColor" });
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedColor" });

      add_vsdbg_configs()
      add_nlua_configs()
    end
  },

  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    init = function ()
      vim.api.nvim_create_user_command('OSVLaunch', function ()
        require("osv").launch({port = 8086})
      end, {})
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",

    lazy = true,

    opts = {
      automatic_installation = true,
      handlers = {
        function(config)
          if config.name == "codelldb" then
            local get_program = make_get_program("codelldb_program")
            local get_args = make_get_args("codelldb_args")

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
              pid = pick_process,
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
    "igorlfs/nvim-dap-view",

    lazy = true,

    keys = {
      { "<leader>dw", "<Cmd>DapViewWatch<CR>", mode = { "n", "v" }, silent = true, desc = "DAP: Add selection to watches" },
      { "<leader>dT", function () require("dap-view").toggle() end, mode = "n", desc = "DAP: Toggle UI (nvim-dap-view)" },
    },

    config = function()
      local dv = require("dap-view")
      local dap = require("dap")

      dv.setup({
        winbar = {
          controls = { enabled = true },
        },
        windows = {
          terminal = { position = "right" },
        },
        switchbuf = "useopen,uselast"
      })

      local open = function ()
        if vim.g.dap_view_enabled then
          dv.open()
        end
      end
      local close = function () dv.close() end

      dap.listeners.before.attach.dap_view_config = open
      dap.listeners.before.launch.dap_view_config = open
      dap.listeners.before.event_terminated.dap_view_config = close
      dap.listeners.before.event_exited.dap_view_config = close
    end
  },

  {
    "rcarriga/nvim-dap-ui",

    lazy = true,

    dependencies = {
      "nvim-neotest/nvim-nio",
    },

    keys = {
      { "<M-k>", function () require("dapui").eval() end, mode = {"n", "v"}, desc = "DAP: Evaluate expression" },
      { "<leader>dt", function () require("dapui").toggle() end, mode = "n", desc = "DAP: Toggle UI (nvim-dap-ui)" },
    },

    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({})

      local open = function ()
        if not vim.g.dap_view_enabled then
          dapui.open()
        end
      end
      local close = function () dapui.close() end

      dap.listeners.before.attach.dap_ui_config = open
      dap.listeners.before.launch.dap_ui_config = open
      dap.listeners.before.event_terminated.dap_ui_config = close
      dap.listeners.before.event_exited.dap_ui_config = close
    end
  },
}
