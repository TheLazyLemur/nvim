return {
    source = "stevearc/oil.nvim",
    depends = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup()
    end
}
