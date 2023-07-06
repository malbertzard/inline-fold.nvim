-- main module file
local module = require("inline-fold.module")

local M = {}
M.config = {
    placeholder = "..."
}

-- setup is the public method to setup your plugin
M.setup = function(args)
    -- you can define your setup function here. Usually configurations can be merged, accepting outside params and
    -- you can also put some validation here for those.
    vim.api.nvim_command("autocmd BufWritePre *.lua lua require('module').restore_classes()")
    vim.api.nvim_command("autocmd BufWritePost *.lua lua require('module').rehide_classes()")
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.toggle = function()
    module.toggle_hide()
end

M.show = function()
    module.restore_classes()
end

M.hide = function()
    module.rehide_classes()
end


return M
