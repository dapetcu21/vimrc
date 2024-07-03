local util = require "userconf.util"

-- Load local configuration
local ok, plugins = util.require_if_exists("local.plugins")
if ok then
  return plugins
end

return {}
