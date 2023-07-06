vim.api.nvim_create_user_command("InlineFoldToggle", require("inline-fold").toggle, {})
vim.api.nvim_create_user_command("InlineFoldShow", require("inline-fold").show, {})
vim.api.nvim_create_user_command("InlineFoldHide", require("inline-fold").hide, {})
