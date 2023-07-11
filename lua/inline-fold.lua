-- main module file
local module = require("inline-fold.module")

local M = {}
M.config = {
  placeholder = "*",
}

-- setup is the public method to setup your plugin
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.toggle = function()
  module.toggle_hide(M.config)
end

return M
