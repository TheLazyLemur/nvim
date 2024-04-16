local modules = {
    {
        m = "modules.bookmarks",
        config = function()
            require("modules.bookmarks").setup()
            vim.keymap.set("n", "<leader>ba", require("modules.bookmarks").bookmark_file)
            vim.keymap.set("n", "<leader>bs", require("modules.bookmarks").show_selection_ui)
        end
    },
    {
        m = "modules.findit",
        config = function()
            require("modules.findit").setup()
            vim.keymap.set("n", "=sg", function() require("modules.findit").grep() end)
            vim.keymap.set("n", "=sf", function() require("modules.findit").find_files() end)
            vim.keymap.set("n", "=sff", function() require("modules.findit").find_files(true) end)
        end
    },
}

for _, module in pairs(modules) do
    require(module.m)
    pcall(module.config)
end
