return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local parsers
      local configs
      local install
      local ok, _ = pcall(function ()
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

      local function disable(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok2, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok2 and stats and stats.size > max_filesize then
          return true
        end
      end

      configs.setup {
        ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "json" },
        ignore_install = ignore_install,
        auto_install = true,
        highlight = {
          enable = true,
          disable = disable,
        },
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
      }
    end,
  },
}
