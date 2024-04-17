local S = {
    is_on = false,
}

return {
    source = "nvim-tree/nvim-tree.lua",
    depends = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.opt.termguicolors = true
        require("nvim-tree").setup()

        vim.keymap.set("n", "<leader>nt", function()
            vim.cmd("NvimTreeFindFile")
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>p', true, false, true), 'n', true)
        end)

        vim.keymap.set('n', '=th', require("nvim-tree.api").tree.toggle_help)
    end
}
