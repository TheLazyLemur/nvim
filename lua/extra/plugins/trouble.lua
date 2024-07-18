return {
  source = "folke/trouble.nvim",
  lazy = true,
  depends = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup()
  end,
}
