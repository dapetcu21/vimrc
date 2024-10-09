return {
  { 'tikhomirov/vim-glsl' },
  { 'ap/vim-css-color' },
  { 'tpope/vim-commentary' },

  {
    'soywod/quicklist.vim',
    keys = {
      { '<leader>q', '<plug>(quicklist-toggle-qf)', mode = 'n', silent = true, desc = 'Toggle quickfix list' },
      { '<leader>l', '<plug>(quicklist-toggle-lc)', mode = 'n', silent = true, desc = 'Toggle location list' },
    },
  },
  {
    'yegappan/greplace',
    keys = {
      { '<leader>gc', '<Cmd>Gqfopen<CR><C-W>L', mode = 'n', silent = true, desc = 'Replace in quickfix' },
    },
  },

  { 'editorconfig/editorconfig-vim' },
  { 'ii14/exrc.vim' },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    'RRethy/vim-illuminate',
    config = function ()
      require('illuminate').configure({
        modes_allowlist = { 'n', 'no' },
        filetypes_deylist = { 'qf', 'trouble', 'NvimTree', 'fzf' },
      })
    end,
  },
  {
    'ntpeters/vim-better-whitespace',
    init = function ()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 0
      vim.g.show_spaces_that_precede_tabs = 1
      vim.g.better_whitespace_filetypes_blacklist= {
        'NvimTree', 'fugitive', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'toggleterm', 'trouble'
      }
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = 'horizontal',
      open_mapping = '<C-t>',
      insert_mappings =  false,
    },
    init = function ()
      -- Use PowerShell on Windows
      if vim.fn.has('win32') == 1 then
        vim.opt.shell = (vim.fn.executable('pwsh') == 1) and 'pwsh' or 'powershell'
        vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        vim.opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
        vim.opt.shellxquote = ''
        vim.opt.shellquote = ''
      end
    end,
  },
}
