local ops = {}

function ops.get_all_files()
    local scan = require 'plenary.scandir'
    local all_files = scan.scan_dir('.', { hidden = false, depth = 20 })
    return all_files
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

local function test_here()
    local width = vim.o.columns / 2
    local height = 0

    if height == 0 then
        height = 1
    end

    local in_buf = vim.api.nvim_create_buf(false, true)
    local _ = vim.api.nvim_open_win(in_buf, true, {
        relative = "editor",
        row = 1,
        col = math.floor(vim.o.columns / 2 - width / 2),
        width = width,
        height = height,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = "Input",
        title_pos = "center",
    })

    local out_buf = vim.api.nvim_create_buf(false, true)
    local _ = vim.api.nvim_open_win(out_buf, false, {
        relative = "editor",
        row = 4,
        col = math.floor(vim.o.columns / 2 - width / 2),
        width = width,
        height = 30,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = "Results",
        title_pos = "center",
    })

    local initial_files = ops.get_all_files()
    local intial_displ = ops.get_view_list(initial_files, 1)
    vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, intial_displ)

    vim.cmd("startinsert")

    local cursorPos = 1
    local list = {}

    vim.keymap.set("i", "<C-n>", function()
        cursorPos = cursorPos + 1
        local filter_value = vim.api.nvim_buf_get_lines(in_buf, 0, -1, false)
        local files = ops.get_all_files()
        list = ops.get_exact_matches(filter_value[1], files)
        local displ = ops.get_view_list(list, cursorPos)

        vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, displ)
    end, { buffer = in_buf })

    vim.keymap.set("i", "<C-p>", function()
        cursorPos = cursorPos - 1
        local filter_value = vim.api.nvim_buf_get_lines(in_buf, 0, -1, false)
        local files = ops.get_all_files()
        list = ops.get_exact_matches(filter_value[1], files)
        local displ = ops.get_view_list(list, cursorPos)

        vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, displ)
    end, { buffer = in_buf })

    vim.keymap.set("i", "<C-q>", function()
        pcall(
            function()
                vim.api.nvim_buf_delete(in_buf, { force = true })
                vim.api.nvim_buf_delete(out_buf, { force = true })
            end
        )
    end, { buffer = in_buf })

    vim.keymap.set("n", "<C-q>", function()
        pcall(
            function()
                vim.api.nvim_buf_delete(in_buf, { force = true })
                vim.api.nvim_buf_delete(out_buf, { force = true })
            end
        )
    end, { buffer = in_buf })

    vim.keymap.set("i", "<C-q>", function()
        pcall(
            function()
                vim.api.nvim_buf_delete(in_buf, { force = true })
                vim.api.nvim_buf_delete(out_buf, { force = true })
            end
        )
    end, { buffer = out_buf })

    vim.keymap.set("n", "<C-q>", function()
        pcall(
            function()
                vim.api.nvim_buf_delete(in_buf, { force = true })
                vim.api.nvim_buf_delete(out_buf, { force = true })
            end
        )
    end, { buffer = out_buf })


    vim.keymap.set("i", "<CR>", function()
        pcall(
            function() vim.api.nvim_buf_delete(in_buf, { force = true }) end
        )
        vim.cmd('stopinsert')
        vim.cmd("e " .. list[cursorPos])
    end, { buffer = in_buf })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = in_buf,
        callback = function()
            local filter_value = vim.api.nvim_buf_get_lines(in_buf, 0, -1, false)
            local files = ops.get_all_files()
            local filtered_files = ops.get_exact_matches(filter_value[1], files)
            list = filtered_files
            local displ = ops.get_view_list(filtered_files, cursorPos)
            vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, displ)
        end
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = in_buf,
        callback = function()
            pcall(
                function() vim.api.nvim_buf_delete(out_buf, { force = true }) end
            )
        end
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = out_buf,
        callback = function()
            pcall(
                function() vim.api.nvim_buf_delete(in_buf, { force = true }) end
            )
        end
    })
end

vim.keymap.set("n", "<leader>ss", test_here, { desc = "Test here" })
