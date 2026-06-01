local api = vim.api
local nvim_get_current_buf = api.nvim_get_current_buf
local utils = require("clangd_extensions.utils")

---@class ClangdExt.SwitchSourceHeader
local M = {}

local function contains(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

local function fallback_handler(callback)
  local fname = vim.fn.expand("%")
  local ext = vim.fn.fnamemodify(fname, ":e")
  local root = vim.fn.fnamemodify(fname, ":r")

  local h_exts = { "h", "hpp" }
  local cpp_exts = { "cpp", "c", "objc" }

  local exts_to_search
  if contains(h_exts, ext) then
    exts_to_search = cpp_exts
  elseif contains(cpp_exts, ext) then
    exts_to_search = h_exts
  else
    callback({})
    return
  end

  for _, ext_candidate in ipairs(exts_to_search) do
    local candidate = root .. "." .. ext_candidate

    if vim.fn.filereadable(candidate) == 1 then
      callback(nil, candidate)
      return
    end

    local public_candidate, count = string.gsub(candidate, "Public", "Private")
    if count > 0 and vim.fn.filereadable(public_candidate) == 1 then
      callback(nil, public_candidate)
      return
    end

    local private_candidate, count = string.gsub(candidate, "Private", "Public")
    if count > 0 and vim.fn.filereadable(private_candidate) == 1 then
      callback(nil, private_candidate)
      return
    end
  end

  callback({})
end

---@param err? lsp.ResponseError
---@param uri? string
local function handler(err, uri)
  utils.validate({
    err = { err, { "table", "nil" }, true },
    uri = { uri, { "string", "nil" }, true },
  })

  if err or not uri or (uri == "") then
    fallback_handler(
      function (err, fname)
        if err or not fname or (fname == "") then
          api.nvim_echo(
            { { "Corresponding file cannot be determined" } },
            false,
            {}
          )
        else
          vim.cmd.edit(fname)
        end
      end
    )
    return
  end

  vim.cmd.edit(vim.uri_to_fname(uri))
end

function M.switch_source_header()
    local bufnr = nvim_get_current_buf()
    utils.buf_request_method("textDocument/switchSourceHeader", {
        uri = vim.uri_from_bufnr(bufnr),
    }, handler, bufnr)
end

return M
