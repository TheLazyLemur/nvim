return {
  source = "nyoom-engineering/oxocarbon.nvim",
  depends = {
    "tjdevries/colorbuddy.nvim",
    { source = "rose-pine/neovim", name = "rosepine" },
    "folke/tokyonight.nvim",
    "jesseleite/nvim-noirbuddy",
  },
  config = function()
    vim.opt.background = "dark"
    vim.cmd("colorscheme rose-pine")
  end
}
