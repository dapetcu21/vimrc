return {
  { 'EdenEast/nightfox.nvim', priority = 1000 },

  {
    "f-person/auto-dark-mode.nvim",
    config = function ()
      require('auto-dark-mode').setup({
        update_interval = 2000,

        set_dark_mode = function()
          vim.cmd("colorscheme nightfox")
          vim.opt.background = "dark"
          vim.cmd("highlight ExtraWhitespace ctermbg=9 guibg=#FF0000")
        end,

        set_light_mode = function()
          vim.cmd("colorscheme dayfox")
          vim.opt.background = "light"
          vim.cmd("highlight ExtraWhitespace ctermbg=9 guibg=#FF0000")
        end,
      })
    end,
  },
}
