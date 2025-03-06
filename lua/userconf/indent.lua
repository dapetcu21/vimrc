local M = {}

M.default = { tabstop = 2, expandtab = true }

M.filetypes = {
  c = { tabstop = 4, expandtab = false },
  cpp = { tabstop = 4, expandtab = false },
  makefile = { tabstop = 4, expandtab = false },
  lua = { patterns = { "*.gui_script", "*.render_script", "*.editor_script", "*.lua_" } },
  glsl = { patterns = { "*.fsh", "*.vsh", "*.fp", "*.vp" } },
  fuior = { patterns = { "*.fui" } },
}

local augroup

local function setup_filetype_patterns(ft_name, ft)
  if ft.patterns then
    ft.autocmd = vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
      group = augroup,
      pattern = ft.patterns,
      callback = function ()
        vim.opt_local.filetype = ft_name
      end
    })
  end
end

M.setup = function ()
  vim.opt.expandtab = M.default.expandtab
  vim.opt.tabstop = M.default.tabstop
  vim.opt.shiftwidth = M.default.tabstop

  augroup = vim.api.nvim_create_augroup("user_indent", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function (event)
      local ft = M.filetypes[event.match]
      if ft ~= nil then
        local editorconfig = vim.b.editorconfig
        if ft.tabstop ~= nil and (editorconfig == nil or editorconfig.indent_style == nil) then
          vim.opt_local.tabstop = ft.tabstop
          vim.opt_local.shiftwidth = ft.tabstop
        end
        if ft.expandtab ~= nil and (editorconfig == nil or editorconfig.indent_size == nil) then
          vim.opt_local.expandtab = ft.expandtab
        end
      end
    end,
  })

  for k, v in pairs(M.filetypes) do
    setup_filetype_patterns(k, v)
  end
end

M.register_filetype = function (ft_name, new_ft)
  local ft = M.filetypes[ft_name] or {}
  for k, v in pairs(new_ft) do
    if k == "patterns" and ft.patterns then
      local has = {}
      for _, vv in ipairs(ft.patterns) do
        has[vv] = true
      end
      for _, vv in ipairs(v) do
        if not has[vv] then
          table.insert(ft.patterns, vv)
          has[vv] = true
        end
      end
    else
      ft[k] = v
    end
  end
  M.filetypes[ft_name] = ft

  if ft.autocmd then
    vim.api.nvim_del_autocmd(ft.autocmd)
    ft.autocmd = nil
  end

  setup_filetype_patterns(ft_name, ft)
end

return M
