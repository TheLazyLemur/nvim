local async = require('plenary.async')
local Job = require 'plenary.job'

local internal = {}

function internal.grep_string(j, _)
    local items = j:result()
    local entries = {}

    local first_100 = {}
    for i = 1, 100 do
        first_100[i] = items[i]
    end

    for _, v in pairs(first_100) do
        local split_parts = {}
        for part in string.gmatch(v, "([^:]+)") do
            table.insert(split_parts, part)
        end

        local combinedString = ""
        for i = 4, #split_parts do
            combinedString = combinedString .. split_parts[i] .. ":"
        end

        local entry = {
            filename = split_parts[1],
            lnum = tonumber(split_parts[2]),
            col = tonumber(split_parts[3]),
            text = combinedString
        }

        table.insert(entries, entry)
    end

    vim.schedule(function()
        vim.fn.setqflist(entries, 'r')
        vim.cmd.copen()
    end)
end

function internal.find_files(items, _, line)
    local first_100 = {}
    for i = 1, 100 do
        first_100[i] = items[i]
    end


    local entries = {}
    for _, v in pairs(first_100) do
        local entry = {
            filename = v,
            lnum = line,
            col = 1,
            text = v
        }

        table.insert(entries, entry)
    end

    vim.schedule(function()
        vim.fn.setqflist(entries, 'r')
        vim.cmd.copen()
    end)
end

local M = {}

function internal.async_grep(str)
    Job:new({
        command = '/opt/homebrew/bin/rg',
        args = { str, '--vimgrep', '--color=never', '--' },
        cwd = vim.fn.getcwd(),
        env = { ['a'] = 'b' },
        interactive = false,
        on_exit = internal.grep_string,
    }):sync()
end

function internal.async_find_files(str, fuzzy)
    local split_parts = {}
    for part in string.gmatch(str, "([^:]+)") do
        table.insert(split_parts, part)
    end

    if fuzzy == nil or fuzzy == false then
        local scan = require 'plenary.scandir'
        local result = scan.scan_dir('.', { hidden = false, depth = 25, search_pattern = split_parts[1] })

        internal.find_files(result, _, split_parts[2])
    end

    if fuzzy ~= nil and fuzzy == true then
        Job:new({
            command = 'sh',
            args = { '-c', '/opt/homebrew/bin/rg --files | /opt/homebrew/bin/fzf --filter ' .. split_parts[1] },
            cwd = vim.fn.getcwd(),
            env = { ['a'] = 'b' },
            interactive = false,
            on_exit = function(j, _)
                internal.find_files(j:result(), _, split_parts[2])
            end,
        }):sync()
    end
end

function M.grep()
    local user_input = vim.fn.input("Enter some text: ")
    if #user_input <= 0 then
        return
    end

    ---@diagnostic disable-next-line: missing-parameter
    async.run(function() internal.async_grep(user_input) end)
end

function M.find_files(fuzzy)
    local user_input = vim.fn.input("Enter some text: ")
    if #user_input <= 0 then
        return
    end
    ---@diagnostic disable-next-line: missing-parameter
    async.run(function() internal.async_find_files(user_input, fuzzy) end)
end

function M.setup()
end

return M
