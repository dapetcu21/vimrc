return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
      local ignore_install= {}
      if is_windows then
        ignore_install = { "astro", "ocaml", "ocaml_interface" }
      end

      configs.setup {
        ensure_installed = parser_list,
        ignore_install = ignore_install,
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
}
