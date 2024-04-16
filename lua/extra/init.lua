local add = MiniDeps.add

add({
    source = "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
})
require("trouble").setup()

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

add({
    source = "nvim-neotest/neotest",
    depends = {
        "nvim-neotest/nvim-nio",
        "nvim-neotest/neotest-go",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
    }
})

---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
  adapters = {
    require("neotest-go")({
    }),
  },
})

vim.keymap.set( "n", "<leader>tt", require("neotest").run.run )
vim.keymap.set( "n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end )
vim.keymap.set( "n", "<leader>ts", require("neotest").summary.open )

add({
  source = "stevearc/oil.nvim",
  depends = { "nvim-tree/nvim-web-devicons" },
})
require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
