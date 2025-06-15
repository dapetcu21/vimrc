local M = {}

local function trim(s)
   return string.match(s, "^%s*(.-)%s*$")
end

local function extract_line_no(path)
  path = trim(path)

  local path_part, line, col

  path_part, line, col = string.match(path, "^(.*)[%(%[:]([0-9]+)[,:]([0-9]+).-$")
  if path_part ~= nil then
    coroutine.yield(path_part, tonumber(line), tonumber(col) - 1)
  end

  path_part, line = string.match(path, "^(.*)[%(%[:]([0-9]+).-$")
  if path_part ~= nil then
    coroutine.yield(path_part, tonumber(line))
  end

  coroutine.yield(path)
end

local function extract_candidates_from_lines(lines)
  for _, line in ipairs(lines) do
    extract_line_no(line)
  end
end

function M.extract_candidates()
  local _, srow, scol = unpack(vim.fn.getpos('v'))
  local _, erow, ecol = unpack(vim.fn.getpos('.'))
  local mode = vim.api.nvim_get_mode().mode

  -- visual line mode
  if mode == 'V' then
    if srow > erow then
      return extract_candidates_from_lines(vim.api.nvim_buf_get_lines(0, erow - 1, srow, true))
    else
      return extract_candidates_from_lines(vim.api.nvim_buf_get_lines(0, srow - 1, erow, true))
    end
  end


  -- regular visual mode
  if mode == 'v' then
    if srow < erow or (srow == erow and scol <= ecol) then
      return extract_candidates_from_lines(vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {}))
    else
      return extract_candidates_from_lines(vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {}))
    end
  end

  -- visual block mode
  if mode == '\22' then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      extract_line_no(
        vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
      )
    end
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, erow - 1, erow, false)[1]
  local prefix = line:sub(1, ecol - 1)
  local suffix = line:sub(ecol)

  local prefix_trimmed = prefix:match("^.*%s(.-)$") or prefix
  local suffix_trimmed = suffix:match("^(._)%s") or suffix
  extract_line_no(prefix_trimmed .. suffix_trimmed)
end

function M.go()
  for fname, row, col in coroutine.wrap(M.extract_candidates) do
    local abs_path = vim.fn.fnamemodify(fname, ":p")
    if vim.uv.fs_stat(abs_path) then
      M.open(abs_path, row, col)
      break
    end
  end
end

function M.open(fname, row, col)
    local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(fname))

    if bufnr == nil then
        return
    end

    local window = require("dap-view.views.windows")
    local win = window.get_win_respecting_switchbuf(vim.o.switchbuf, bufnr)

    if not win then
        win = vim.api.nvim_open_win(0, true, {
            split = "left",
            win = -1,
        })
    end

    vim.api.nvim_win_call(win, function()
        vim.api.nvim_set_current_buf(bufnr)
    end)

    if row or col then
      vim.api.nvim_win_set_cursor(win, { row or 0, col or 0 })
    end

    vim.api.nvim_set_current_win(win)
end

return M
