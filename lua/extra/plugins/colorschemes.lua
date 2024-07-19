return {
  source = "nyoom-engineering/oxocarbon.nvim",
  depends = {
    "folke/tokyonight.nvim",
  },
  config = function()
    vim.opt.background = "dark"
    -- vim.cmd.colorscheme "oxocarbon"
    vim.cmd.colorscheme "tokyonight-night"
  end
}
