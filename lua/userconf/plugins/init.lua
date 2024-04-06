return {
  { 'tikhomirov/vim-glsl' },
  { 'ap/vim-css-color' },
  { 'tpope/vim-commentary' },

  {
    'soywod/quicklist.vim',
    keys = {
      { '<leader>c', '<plug>(quicklist-toggle-qf)', mode = 'n', silent = true },
      { '<leader>l', '<plug>(quicklist-toggle-lc)', mode = 'n', silent = true },
    },
  },
  {
    'yegappan/greplace',
    keys = {
      { '<leader>gc', '<Cmd>Gqfopen<CR><C-W>L', mode = 'n', silent = true },
    },
  },

  { 'editorconfig/editorconfig-vim' },
  { 'ii14/exrc.vim' },

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

  {
    'caenrique/buffer-term.nvim',
    keys = {
      { '<space>t', function () require('buffer-term').toggle(1) end, mode = 'n', silent = true },
    }
  },
}
