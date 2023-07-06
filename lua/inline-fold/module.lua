local M = {}

local hide = false
local original_classes = {}
local tick_values = {}

local function find_class(line_content)
    local start_pos, end_pos, class_value = string.find(line_content, 'class="([^"]*)"')
    return start_pos, end_pos, class_value
end

local function store_original_class(bufnr, line, class_value)
    if not original_classes[bufnr] then
        original_classes[bufnr] = {}
    end
    original_classes[bufnr][line] = class_value
end

local function restore_original_class(bufnr, line)
    local original_class = original_classes[bufnr] and original_classes[bufnr][line]
    if original_class then
        original_classes[bufnr][line] = nil
        return original_class
    end
    return nil
end

local function generate_tag_id(bufnr, line)
    return bufnr .. ":" .. line
end

local function update_buffer(bufnr)
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)

    if tick_values[bufnr] and tick_values[bufnr] == tick then
        -- No changes in the buffer, no need to update
        return
    end

    tick_values[bufnr] = tick

    vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

    local line_count = vim.api.nvim_buf_line_count(bufnr)

    for line = 1, line_count do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

        local start_pos, end_pos, class_value = find_class(line_content)

        if start_pos and end_pos then
            local tag_id = generate_tag_id(bufnr, line)

            if hide then
                store_original_class(bufnr, tag_id, class_value)
                local new_line = line_content:gsub('class="[^"]+"', 'class="..."')
                vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { new_line })
            else
                local original_class = restore_original_class(bufnr, tag_id)
                if original_class then
                    local new_line = line_content:gsub('class="..."', 'class="' .. original_class .. '"')
                    vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { new_line })
                end
            end
        end
    end
end

function M.toggle_hide()
    hide = not hide

    local bufnr = vim.api.nvim_get_current_buf()
    update_buffer(bufnr)
end

function M.restore_classes()
    local bufnr = vim.api.nvim_get_current_buf()
    
    hide = false
    update_buffer(bufnr)
end

function M.rehide_classes()
    local bufnr = vim.api.nvim_get_current_buf()

    hide = true
    update_buffer(bufnr)
end

return M

