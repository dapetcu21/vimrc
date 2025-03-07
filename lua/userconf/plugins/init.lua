local utility_file_types = {
  'NvimTree', 'fugitive', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'fzf', 'toggleterm', 'trouble', 'snacks_dashboard', 'snacks_picker_input', 'snacks_picker_preview'
}

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

  { 'ii14/exrc.vim' },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    'RRethy/vim-illuminate',
    config = function ()
      require('illuminate').configure({
        modes_allowlist = { 'n', 'no' },
        filetypes_deylist = utility_file_types
      })
    end,
  },
  {
    'ntpeters/vim-better-whitespace',
    event = 'BufReadPre',
    init = function ()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 0
      vim.g.show_spaces_that_precede_tabs = 1
      vim.g.better_whitespace_filetypes_blacklist = utility_file_types
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
    cmd = {
      "ToggleTerm",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
      "ToggleTermSetName",
      "ToggleTermToggleAll",
    },
    keys = {
      { "<C-t>", mode = "n", desc = "Toggle Terminal" },
    },

    init = function ()
      -- Use PowerShell on Windows
      if vim.fn.has('win32') == 1 then
        vim.opt.shell = (vim.fn.executable('pwsh') == 1) and 'pwsh' or 'powershell'
        vim.opt.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
        vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
        vim.opt.shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
        vim.opt.shellquote = ''
        vim.opt.shellxquote = ''
      end
    end,
  },
}
