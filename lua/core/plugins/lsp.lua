return {
    source = "neovim/nvim-lspconfig",
    depends = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        require("neodev").setup()
        require("mason").setup()
        require("mason-tool-installer").setup {}
        require("mason-lspconfig").setup {
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
            },
        }
        require('mini.completion').setup()
    end
}
