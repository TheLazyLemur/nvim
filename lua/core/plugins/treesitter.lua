return {
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    monitor = "main",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vimdoc", "go", "markdown" },
            highlight = { enable = true },
        })
    end
}
