return {
  { 'morhetz/gruvbox', priority = 1000 },
  { 'sainnhe/gruvbox-material', priority = 1000 },
  { 'EdenEast/nightfox.nvim', priority = 1000 },

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
  },
}
