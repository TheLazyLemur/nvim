return {
  source = "nyoom-engineering/oxocarbon.nvim",
  depends = {
    "tjdevries/colorbuddy.nvim",
    "folke/tokyonight.nvim",
    "jesseleite/nvim-noirbuddy",
    "miikanissi/modus-themes.nvim",
  },
  config = function()
    vim.opt.background = "dark"
    vim.cmd("colorscheme noirbuddy")
  end
}
