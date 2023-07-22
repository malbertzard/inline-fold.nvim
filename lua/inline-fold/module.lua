-- module file (inline-fold.module)
local M = {}

local isHidden = false

local function findQueryMatches(lineContent, query)
  local start, stop, match = string.find(lineContent, query.pattern)
  return start, stop, match
end

local function prefixSpecialCharacters(inputString)
  local specialCharacters = {
    ["["] = true,
    ["]"] = true,
    ["{"] = true,
    ["}"] = true,
    ["/"] = true,
  }

  local result = ""
  for i = 1, #inputString do
    local char = inputString:sub(i, i)
    if specialCharacters[char] then
      result = result .. "\\" .. char
    else
      result = result .. char
    end
  end

  return result
end

local function createConcealMatch(text, placeholder)
  local syntaxGroup = "InlineFold" -- Name of the syntax group
  local concealChar = placeholder

  -- Define the syntax group and conceal the match
  vim.cmd("syntax match " .. syntaxGroup .. " /" .. text .. "/ conceal cchar=" .. concealChar)

  -- Set the concealment options
  vim.cmd("highlight! link " .. syntaxGroup .. " Conceal")

  -- Refresh the buffer to apply the concealment
  vim.api.nvim_buf_call(0, function()
    vim.cmd("syntax sync fromstart")
  end)
end

local function removeConcealment()
  local syntaxGroup = "InlineFold" -- Name of the syntax group

  -- Clear the syntax group
  vim.cmd("syntax clear " .. syntaxGroup)

  -- Refresh the buffer to remove the concealment
  vim.api.nvim_buf_call(0, function()
    vim.cmd("syntax sync fromstart")
  end)
end

local function updateBuffer(bufnr, filetype, queries, defaultPlaceholder)
  vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

  local lineCount = vim.api.nvim_buf_line_count(bufnr)

  local filetypeQueries = queries[filetype] -- Get filetype-specific queries

  if not filetypeQueries then
    return
  end

  for line = 1, lineCount do
    local lineContent = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

    for _, query in ipairs(filetypeQueries) do
      local start, stop, match = findQueryMatches(lineContent, query)

      if start and stop then
        local placeholder = query.placeholder or defaultPlaceholder

        if isHidden then
          match = prefixSpecialCharacters(match)
          createConcealMatch(match, placeholder)
        else
          removeConcealment()
        end
      end
    end
  end
end

local function setConcealLevel(bufnr)
  local cmd = string.format("setlocal conceallevel=2")
  vim.api.nvim_buf_call(bufnr, function()
    vim.api.nvim_command(cmd)
  end)
end

function M.toggleHide(conf)
  isHidden = not isHidden

  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype") -- Get the current filetype
  setConcealLevel(bufnr)
  updateBuffer(bufnr, filetype, conf.queries, conf.defaultPlaceholder)
end

return M
