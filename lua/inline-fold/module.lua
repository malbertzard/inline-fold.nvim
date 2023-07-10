local M = {}

local hide = false
local original_classes = {}

local function find_class(line_content)
    local start_pos, end_pos, class_value = string.find(line_content, 'class="([^"]*)"')
    return start_pos, end_pos, class_value
end

local function create_conceal(text)
    local syntax_group = "InlineFold" -- Name of the syntax group
    local conceal_char = "*" -- Character to use for concealment

    -- Define the syntax group
    vim.cmd("syntax match " .. syntax_group .. " /" .. text .. "/ conceal cchar=" .. conceal_char)

    -- Set the concealment options
    vim.cmd("highlight! link " .. syntax_group .. " Conceal")

    -- Refresh the buffer to apply the concealment
    vim.api.nvim_buf_call(0, function()
        vim.cmd("syntax sync fromstart")
    end)
end

local function update_buffer(bufnr)
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)

    vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

    local line_count = vim.api.nvim_buf_line_count(bufnr)

    for line = 1, line_count do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

        local start_pos, end_pos, class_value = find_class(line_content)

        if start_pos and end_pos then
            if hide then
                create_conceal(class_value)
            else
            end
        end
    end
end

function M.toggle_hide()
    hide = not hide

    local bufnr = vim.api.nvim_get_current_buf()
    update_buffer(bufnr)
end

return M

