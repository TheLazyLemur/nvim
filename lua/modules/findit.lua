local ops = {
}

function ops.get_all_files(input)
    if input then
        return ops.execute_shell_command({ "sh", "-c", "fd . --type f | rg " .. input })
    end

    return ops.execute_shell_command({ "fd", ".", "--type", "f" })
end

function ops.get_exact_matches(value, list)
    local exact_matches = {}
    for _, v in ipairs(list) do
        local match = string.match(v, value)
        if match then
            table.insert(exact_matches, v)
        end
    end

    return exact_matches
end

function ops.get_view_list(list, cursorPos)
    local view_list = {}

    for i, v in ipairs(list) do
        if i ~= cursorPos then
            view_list[i] = v
        else
            view_list[i] = "> " .. v
        end
    end

    return view_list
end

function ops.execute_shell_command(command)
    local out = vim.fn.system(command)
    local lines = {}
    for line in out:gmatch("([^\n]*)\n?") do
        table.insert(lines, line)
    end

    return lines
end

local M = {
    prompt = "FindIt> ",
}

function M.find_files()
    local width = math.floor(vim.o.columns / 3)
    local height = 0

    if height == 0 then
        height = 1
    end

    local in_buf = vim.api.nvim_create_buf(false, true)
    local _ = vim.api.nvim_open_win(in_buf, true, {
        relative = "editor",
        row = 1,
        col = 0,
        width = width * 2 + 3,
        height = height,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = " Input ",
        title_pos = "center",
    })

    local out_buf = vim.api.nvim_create_buf(false, true)
    local out_win = vim.api.nvim_open_win(out_buf, false, {
        relative = "editor",
        row = 4,
        col = 0,
        width = width,
        height = 30,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = " Results ",
        title_pos = "center",
    })

    local prev_buf = vim.api.nvim_create_buf(false, true)
    local _ = vim.api.nvim_open_win(prev_buf, false, {
        relative = "editor",
        row = 4,
        col = 0 + width + 3,
        width = width,
        height = 30,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = " Preview ",
        title_pos = "center",
    })
    vim.api.nvim_set_option_value("filetype", "lua", { buf = prev_buf })

    local initial_files = ops.get_all_files()
    local intial_displ = ops.get_view_list(initial_files, 1)
    vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, intial_displ)

    vim.cmd("startinsert")

    local cursorPos = 1
    local list = initial_files

    vim.keymap.set("i", "<C-n>", function()
        cursorPos = cursorPos + 1
        if cursorPos > #list then
            cursorPos = #list
        end

        if cursorPos < 1 then
            cursorPos = 1
        end

        local displ = ops.get_view_list(list, cursorPos)

        local ls_output = ops.execute_shell_command({ 'bat', list[cursorPos] })

        vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, displ)
        vim.api.nvim_buf_set_lines(prev_buf, 0, -1, false, ls_output)
        vim.api.nvim_win_set_cursor(out_win, { cursorPos, 0 })
    end, { buffer = in_buf })

    vim.keymap.set("i", "<C-p>", function()
        cursorPos = cursorPos - 1
        if cursorPos > #list then
            cursorPos = #list
        end

        if cursorPos < 1 then
            cursorPos = 1
        end

        local displ = ops.get_view_list(list, cursorPos)

        local ls_output = ops.execute_shell_command({ 'bat', list[cursorPos] })

        vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, displ)
        vim.api.nvim_buf_set_lines(prev_buf, 0, -1, false, ls_output)
        vim.api.nvim_win_set_cursor(out_win, { cursorPos, 0 })
    end, { buffer = in_buf })

    vim.keymap.set("i", "<CR>", function()
        pcall(
            function() vim.api.nvim_buf_delete(in_buf, { force = true }) end
        )
        vim.cmd('stopinsert')
        vim.cmd("e " .. list[cursorPos])
    end, { buffer = in_buf })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = in_buf,
        group = vim.api.nvim_create_augroup("FindIt-Input-TextChanged", { clear = true }),
        callback = function()
            cursorPos = 1
            local filter_value = vim.api.nvim_buf_get_lines(in_buf, 0, -1, false)
            local filtered_files = ops.get_all_files(filter_value[1])
            list = filtered_files
            local displ = ops.get_view_list(filtered_files, cursorPos)

            if list[cursorPos] then
                local ls_output = ops.execute_shell_command('bat ' .. list[cursorPos])
                vim.api.nvim_buf_set_lines(prev_buf, 0, -1, false, ls_output)
            else
                vim.api.nvim_buf_set_lines(prev_buf, 0, -1, false, {})
            end

            vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, displ)
        end
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = in_buf,
        group = vim.api.nvim_create_augroup("FindIt-Input-BufLeave", { clear = true }),
        callback = function()
            pcall(
                function()
                    vim.api.nvim_buf_delete(in_buf, { force = true })
                    vim.api.nvim_buf_delete(out_buf, { force = true })
                    vim.api.nvim_buf_delete(prev_buf, { force = true })
                end
            )
        end
    })
end

function M.setup(opts)
end

return M
