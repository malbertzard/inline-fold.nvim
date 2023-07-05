local M = {}

-- Store the current hide state
local hide = false

-- Store the original line values
local original_lines = {}

function M.toggle_hide()
    hide = not hide

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

    local line_count = vim.api.nvim_buf_line_count(bufnr)
    for line = 1, line_count do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

        -- Find the class attribute and its value
        local start_pos, end_pos, class_value = string.find(line_content, 'class="([^"]*)"')

        if start_pos and end_pos then
            if hide then
                -- Store the original line value
                original_lines[vim.api.nvim_buf_get_name(bufnr) .. ':' .. line] = line_content
                local new_line = line_content:gsub('class="[^"]+"', 'class="..."')

                vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { new_line })
            else
                -- Restore the original class value
                local original_line = original_lines[vim.api.nvim_buf_get_name(bufnr) .. ':' .. line]
                if original_line then
                    -- Update the line with the original content
                    vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { original_line })
                end
            end
        end
    end
end

-- Function to restore original line values on file save, exit, or VimLeavePre
local function restore_original_lines()
    for key, line_content in pairs(original_lines) do
        local file, line_number = key:match('(.*):(%d+)')
        if vim.fn.filereadable(file) == 1 then
            local bufnr = vim.fn.bufnr(file)
            if bufnr ~= -1 then
                vim.api.nvim_buf_set_lines(bufnr, tonumber(line_number) - 1, tonumber(line_number), false,
                    { line_content })
            end
        end
    end
    original_lines = {}
end

return M