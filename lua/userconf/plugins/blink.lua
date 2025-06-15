return {
  {
    'saghen/blink.cmp',
    version = 'v1.3.1',

    dependencies = 'rafamadriz/friendly-snippets',

    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h"] = { "snippet_backward", "fallback" },
      },

      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true },
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
  },
}
