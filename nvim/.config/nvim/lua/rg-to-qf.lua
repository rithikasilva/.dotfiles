local function search_with_ripgrep()
  vim.ui.input({ prompt = "Ripgrep arguments (no `rg` prefix): " }, function(input)
    if not input or input == "" then
      vim.notify("No input given", vim.log.levels.WARN)
      return
    end

    local cmd = string.format("rg --vimgrep %s", input)
    local output = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 or #output == 0 then
      vim.notify("No matches found or rg failed", vim.log.levels.INFO)
      return
    end

    local qf_list = {}
    for _, line in ipairs(output) do
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

    vim.fn.setqflist(qf_list, 'r')
    vim.cmd("copen")
  end)
end

vim.keymap.set("n", "<leader>rq", search_with_ripgrep, { desc = "Ripgrep to Quickfix" })
