return {
    source = "akinsho/bufferline.nvim",
    depends = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.opt.termguicolors = true
        require("bufferline").setup({
            options = {
                separator_style = "padded_slant",
                diagnostics = "nvim_lsp",
            },
        })

        vim.keymap.set("n", "<Tab>", function() require("bufferline").cycle(1) end)
        vim.keymap.set("n", "<S-Tab>", function() require("bufferline").cycle(-1) end)
        vim.keymap.set("n", "<leader><Tab>", function() require("bufferline").pick() end)
        for i = 1, 5 do
            vim.keymap.set("n", "<C-t>" .. i, function() require("bufferline").go_to(i) end)
        end
    end
}
