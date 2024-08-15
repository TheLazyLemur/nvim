local function find_repo_base()
    local current_dir = vim.fn.expand('%:p:h')
    local found = vim.fn.findfile('.gitignore', current_dir .. ';')
    if found == "" then
        print("go.mod not found in any parent directory.")
        return nil
    else
        return vim.fn.fnamemodify(found, ":p:h")
    end
end

local function run_lint()
    local lv_output = vim.fn.systemlist({ "golangci-lint", "run", "--allow-parallel-runners",
        "--print-issued-lines=false",
        "--color=never", vim.fn.expand('%:p:h') })

    local qf_list = {}

    for _, line in pairs(lv_output) do
        local filepath, lnum, col, msg = line:match("([^:]+):(%d+):(%d+):%s*(.*)")
        if filepath and lnum and col and msg then
            table.insert(qf_list, {
                filename = filepath,
                lnum = tonumber(lnum),
                col = tonumber(col),
                text = msg,
                type = 'W'
            })
        end
    end

    return qf_list
end

local function run_luno_lint()
    local lv_output = vim.fn.systemlist({ "golint", vim.fn.expand('%:p:h') })

    local qf_list = {}

    for _, line in pairs(lv_output) do
        local filepath, lnum, col, msg = line:match("([^:]+):(%d+):(%d+):%s*(.*)")
        if filepath and lnum and col and msg then
            table.insert(qf_list, {
                filename = filepath,
                lnum = tonumber(lnum),
                col = tonumber(col),
                text = msg,
                type = 'W'
            })
        end
    end

    return qf_list
end


local function run_luno_vet()
    local lv_output = vim.fn.systemlist({ "lunovet", vim.fn.expand('%:p:h') })

    local qf_list = {}

    for _, line in pairs(lv_output) do
        local filepath, lnum, col, msg = line:match("([^:]+):(%d+):(%d+):%s*(.*)")
        if filepath and lnum and col and msg then
            table.insert(qf_list, {
                filename = filepath,
                lnum = tonumber(lnum),
                col = tonumber(col),
                text = msg,
                type = 'E'
            })
        end
    end

    return qf_list
end

local function run_luno_imports()
    local current_file = vim.fn.expand("%:p")
    local base_pos = find_repo_base()

    local cpos = vim.fn.getpos(".")

    pcall(vim.cmd("%!sh -c 'cd " .. base_pos .. " && lunoimports -stdout " .. current_file .. "'"))

    vim.fn.setpos(".", cpos)
    vim.cmd("write")
end

local function run_go_fumpt()
    local current_file = vim.fn.expand("%:p")
    local base_pos = find_repo_base()

    local cpos = vim.fn.getpos(".")

    pcall(vim.cmd("%!sh -c 'cd " .. base_pos .. " && gofumpt " .. current_file .. "'"))

    vim.fn.setpos(".", cpos)
    vim.cmd("write")
end

local M = {}

local is_formatting = false
local cooldown = 5
local last_format_time = 0

M.run_format = function()
    local current_time = os.time()

    if current_time - last_format_time < cooldown then
        print("Autocommand on cooldown, skipping format.")
        return
    end

    if is_formatting then
        return
    end
    is_formatting = true

    vim.cmd("silent! write")
    run_go_fumpt()
    vim.cmd("silent! write")
    run_luno_imports()
    vim.cmd("silent! write")

    last_format_time = current_time

    is_formatting = false
end

M.run_diagnostics = function()
    local qf_list = {}

    local vets = run_luno_vet()
    for _, vet in ipairs(vets) do
        table.insert(qf_list, vet)
    end

    -- local lint_res = run_luno_lint()
    -- for _, lint in ipairs(lint_res) do
    --     table.insert(qf_list, lint)
    -- end

    local lr = run_lint()
    for _, lint in ipairs(lr) do
        table.insert(qf_list, lint)
    end

    if #qf_list > 0 then
        vim.fn.setqflist(qf_list, 'r')
        vim.cmd("copen")
    end
end

return M
