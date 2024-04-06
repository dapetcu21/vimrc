return {
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
}
