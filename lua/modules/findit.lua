local ops = {}

function ops.get_all_files(input)
    if input or input == "" then
        return ops.execute_shell_command({ "sh", "-c", "fd . --type f | fzf --filter " .. input })
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
        if line ~= "" then
            table.insert(lines, line)
        end
    end

    return lines
end

local M = {
    prompt = "FindIt> ",
}

function M.find_files()
    local container_width = math.floor(vim.o.columns / 1.3)
    local container_height = math.floor(vim.o.lines / 1.3)

    local container_x = math.floor((vim.o.columns - container_width) / 2)
    local container_y = math.floor((vim.o.lines - container_height) / 2)

    local input_width = math.floor(container_width * 0.5)
    local input_height = 1
    local in_buf = vim.api.nvim_create_buf(false, true)
    local in_win = vim.api.nvim_open_win(in_buf, true, {
        relative = "editor",
        row = container_y + container_height - input_height,
        col = container_x,
        width = input_width,
        height = input_height,
        style = "minimal",
        border = "rounded",
        title = " Input ",
        title_pos = "center",
    })

    local result_width = math.floor(container_width * 0.5)
    local result_height = math.floor((container_height) - container_height * 0.05) - input_height
    local out_buf = vim.api.nvim_create_buf(false, true)
    local out_win = vim.api.nvim_open_win(out_buf, false, {
        relative = "editor",
        row = container_y,
        col = container_x,
        width = result_width,
        height = result_height,
        style = "minimal",
        border = "rounded",
        title = " Result ",
        title_pos = "center",
    })

    local preview_width = math.floor(container_width * 0.5)
    local preview_height = container_height
    local prev_buf = vim.api.nvim_create_buf(false, true)
    local prev_win = vim.api.nvim_open_win(prev_buf, false, {
        relative = "editor",
        row = container_y,
        col = container_x + preview_width + 3,
        width = preview_width,
        height = preview_height,
        style = "minimal",
        border = "rounded",
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

    vim.keymap.set("n", "<ESC>", function()
        pcall(
            function() vim.api.nvim_buf_delete(in_buf, { force = true }) end
        )
        vim.cmd('stopinsert')
    end, { buffer = in_buf })

    vim.keymap.set("i", "<C-n>", function()
        cursorPos = cursorPos + 1
        if cursorPos > #list then
            cursorPos = #list
        end

        if cursorPos < 1 then
            cursorPos = 1
        end

        local displ = ops.get_view_list(list, cursorPos)

        local ext = vim.fn.fnamemodify(list[cursorPos], ":e")
        vim.api.nvim_set_option_value("filetype", ext, { buf = prev_buf })
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
