local M = {}

function M.create_task()
    local title = vim.fn.input("Task: ")
    local id = os.time()   local date = vim.fn.input("Date (YYYY-MM-DD): ")
    if not date:match("^%d%d%d%d%-%d%d%-%d%d$") then
        print("Invalid date format. Please use YYYY-MM-DD.")
        return
    end
    local task_line = string.format("- [ ] %s 🆔 %d 📅 %s", title, id, date)
    vim.api.nvim_put({task_line}, "l", true, true)
end

vim.api.nvim_create_user_command("NewTask", M.create_task, {})
vim.api.nvim_set_keymap('n', '<leader>tc', ':NewTask<CR>', { noremap = true, silent = true })

return M



