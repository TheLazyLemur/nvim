return {
  source = "nvim-neotest/neotest",
  lazy = true,
  depends = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-go",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      adapters = {
        require("neotest-go")({}),
      },
    })

    vim.keymap.set("n", "<leader>tt", require("neotest").run.run)
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end)
    vim.keymap.set("n", "<leader>ts", require("neotest").summary.open)
  end
}
