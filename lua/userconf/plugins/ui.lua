return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      popupmenu = {
        enabled = true,
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim"
    }
  },

  {
    "folke/trouble.nvim",

    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },

    opts = {
      focus = true,
      modes = {
        symbols = {
          win = { position = "right", size = 80 },
        },
        lsp = {
          win = { position = "right", size = 80 },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>td",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Trouble: Diagnostics",
      },
      {
        "<leader>tD",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Trouble: Buffer diagnostics",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Trouble: Symbols",
      },
      {
        "<leader>tk",
        "<cmd>Trouble snacks toggle<cr>",
        desc = "Trouble: Snacks",
      },
      {
        "<leader>tp",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "Trouble: LSP definitions / references / ...",
      },
      {
        "<leader>tl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Trouble: Location list",
      },
      {
        "<leader>tq",
       "<cmd>Trouble qflist toggle<cr>",
        desc = "Trouble: Quickfix list",
      },
    },
  }
}
