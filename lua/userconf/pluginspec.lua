local plugins = {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "call fzf#install()" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("fzf-lua").setup({
        grep = {
          rg_glob = true,
        },
      })
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        view = {
          width = 50,
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdateSync",
    config = function()
      local parsers
      local configs
      local install
      local ok, err = pcall(function ()
        parsers = require "nvim-treesitter.parsers"
        configs = require "nvim-treesitter.configs"
        install = require "nvim-treesitter.install"
      end)
      if not ok then return end

      local is_windows = vim.uv.os_uname().sysname:find("Windows") and true or false
      if is_windows then
        table.insert(install.compilers, "C:\\Program Files\\LLVM\\bin\\clang.exe")
        install.prefer_git = false
      end

      local parser_config = parsers.get_parser_configs()
      parser_config.fuior = {
        install_info = {
          url = "https://github.com/critique-gaming/tree-sitter-fuior", -- local path or git repo
          branch = "main",
          files = {"src/parser.c"},
        },
      }

      local parser_list = parsers.available_parsers()
      table.insert(parser_list, "fuior")

      -- A few parsers don't compile on Windows
      if is_windows then
        local parser_count = #parser_list
        local i = 1
        while i <= parser_count do
          local v = parser_list[i]
          if v == "astro" or v == "ocaml" or v == "ocaml_interface" then
            table.remove(parser_list, i)
            parser_count = parser_count - 1
          else
            i = i + 1
          end
        end
      end

      configs.setup {
        ensure_installed = parser_list,
        highlight = { enable = true },
        indent = { enable = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = {"BufWrite", "CursorHold"},
        },
      }
    end,
  },

  {
    'tpope/vim-fugitive',
    init = function ()
      function toggle_git_status()
        if vim.fn.buflisted(vim.fn.bufname('.git//')) == 1 then
          vim.cmd('bd .git//')
        else
          vim.cmd('G')
        end
      end

      vim.keymap.set('n', '<space>g', toggle_git_status)

      vim.cmd([[
        function! TryWincmdL()
          try
            wincmd L
          catch /.*/
          endtry
        endfunction
        autocmd User FugitiveIndex silent call TryWincmdL()
      ]])
    end,
  },

  { 'tikhomirov/vim-glsl' },
  { 'tpope/vim-commentary' },

  { 'morhetz/gruvbox', priority = 1000 },
  { 'sainnhe/gruvbox-material', priority = 1000 },
  { 'EdenEast/nightfox.nvim', priority = 1000 },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup({
        extensions = { 'nvim-tree', 'nvim-dap-ui', 'quickfix' },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'diff', 'diagnostics'},
          lualine_c = {
            { 'filename', newfile_status = true }
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
        tabline = {
          lualine_a = {
            {
              function ()
                local possession_status = require("nvim-possession").status()
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
            }
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {'tabs'}
        }
      })
    end,
  },

  { 'soywod/quicklist.vim' },
  { 'yegappan/greplace' },

  {
    'ntpeters/vim-better-whitespace',
    init = function ()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 1
      vim.g.show_spaces_that_precede_tabs = 1
      vim.g.better_whitespace_filetypes_blacklist= {
        'NvimTree', 'fugitive', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown'
      }
    end,
  },
  { 'editorconfig/editorconfig-vim' },
  { 'ap/vim-css-color' },
  { 'rhysd/vim-clang-format' },

  { 'ii14/exrc.vim' },

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

      lsp.clangd.setup(coq.lsp_ensure_capabilities({}))

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
  },

  {
    "gennaro-tedesco/nvim-possession",
    dependencies = { "ibhagwan/fzf-lua" },
    config = {
      autoload = true,
      autoswitch = {
        enable = true,
      },

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

      local possession = require("nvim-possession")
      vim.keymap.set("n", "<space>sl", function()
        possession.list()
      end)
      vim.keymap.set("n", "<space>sn", function()
        possession.new()
      end)
      vim.keymap.set("n", "<space>su", function()
        possession.update()
      end)
      vim.keymap.set("n", "<space>sd", function()
        possession.delete()
      end)
    end,
  },

  {
    "f-person/auto-dark-mode.nvim",
    config = function ()
      function set_term_profile(profile)
        if vim.env.TERM_PROGRAM ~= "iTerm.app" then
          return
        end
        vim.cmd("new")
        vim.cmd([[call setline(1, "\033]50;SetProfile=]] .. profile .. [[\007")]])
        vim.cmd("write >> /dev/stdout")
        vim.cmd("q!")
      end

      require('auto-dark-mode').setup({
        update_interval = 1000,

        set_dark_mode = function()
          vim.opt.background = "dark"
          vim.cmd("colorscheme nightfox")
          vim.cmd("highlight ExtraWhitespace ctermbg=9 guibg=#FF0000")
          set_term_profile("Light")
        end,

        set_light_mode = function()
          vim.opt.background = "light"
          vim.cmd("colorscheme gruvbox")
          vim.cmd("highlight ExtraWhitespace ctermbg=9 guibg=#FF0000")
          set_term_profile("Default")
        end,
      })
    end,
  }
}

local local_plugins_path = vim.fn.stdpath("config") .. "/local_pluginspec.lua"
if (vim.fn.filereadable(local_plugins_path) == 1) then
  local local_plugins = dofile(local_plugins_path)
  for i, v in ipairs(local_plugins) do
    plugins[#plugins + 1] = v
  end
end

return plugins
