return {
  source = "folke/trouble.nvim",
  lazy = true,
  config = function()
    require("trouble").setup()
  end,
}
