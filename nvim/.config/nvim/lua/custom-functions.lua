local function search_git_name_with_rg()
  -- Step 1: Get Git user name
  local handle = io.popen("git config user.name")
  if not handle then
    vim.notify("Failed to get Git user.name", vim.log.levels.ERROR)
    return
  end

  local git_name = vim.trim(handle:read("*a"))
  handle:close()

  if git_name == "" then
    vim.notify("Git user.name is empty", vim.log.levels.ERROR)
    return
  end

  -- Step 2: Use ripgrep to find matches in files
  local rg_cmd = string.format("rg --vimgrep %q", git_name)
  local output = vim.fn.systemlist(rg_cmd)

  if vim.v.shell_error ~= 0 or #output == 0 then
    vim.notify("No matches found for Git name: " .. git_name, vim.log.levels.INFO)
    return
  end

  -- Step 3: Parse output into quickfix list
  local qf_list = {}
  for _, line in ipairs(output) do
    -- format: file:line:col:text
    local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.*)")
    if filename and lnum and col and text then
      table.insert(qf_list, {
        filename = filename,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text
      })
    end
  end

  -- Step 4: Populate quickfix list
  vim.fn.setqflist(qf_list, 'r')
  vim.cmd("copen")
end


vim.keymap.set("n", "<leader>gn", search_git_name_with_rg, { desc = "Search Git name in files (Quickfix)" })

