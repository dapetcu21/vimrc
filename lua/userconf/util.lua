local M = {}

local function is_module_available(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end
M.is_module_available = is_module_available

function M.require_if_exists(name)
  if not is_module_available(name) then
    return false, nil
  end
  return true, require(name)
end

return M
