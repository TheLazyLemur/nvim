return {
    source = "nvim-telescope/telescope.nvim",
    depends = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-tree/nvim-web-devicons"
    },
    version = false,
    hooks = {
        post_checkout = function() vim.cmd("TSUpdate") end
    },
    config = function()
        require("telescope").setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        }

        pcall(require("telescope").load_extension, "ui-select")
    end
}
