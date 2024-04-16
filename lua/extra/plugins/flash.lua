return {
  source = "folke/flash.nvim",
  config = function()
    require("flash").setup({
      modes = {
        search = {
          enabled = true,
        },
      },
    })

    vim.keymap.set("n", "<leader>jj", function() require("flash").jump() end)
    vim.keymap.set("n", "<leader>jt", function() require("flash").treesitter() end)
  end
}
