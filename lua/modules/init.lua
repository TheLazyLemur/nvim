local modules = {
    {
        m = "modules.bookmarks",
        config = function()
            require("modules.bookmarks").setup()
            vim.keymap.set("n", "<leader>ba", require("modules.bookmarks").bookmark_file)
            vim.keymap.set("n", "<leader>bs", require("modules.bookmarks").show_selection_ui)
        end
    },
}

for _, module in pairs(modules) do
    require(module.m)
    pcall(module.config)
end
