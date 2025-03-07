local ok, stat = pcall(function()
  return vim.uv.fs_stat(vim.fn.stdpath("config") .. "/lua/local/init.lua")
end)

local M = {}

if ok and stat ~= nil and stat.type == "file" then
  M = require("local.init") or {}
  assert(type(M) == "table")
end

M.plugins = M.plugins or function () return {} end
M.setup = M.setup or function () end

return M
