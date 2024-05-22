return {
  source = "hiasr/vim-zellij-navigator.nvim",
  depends = {
    "swaits/zellij-nav.nvim",
  },
  config = function()
    require("zellij-nav").setup()
    require('vim-zellij-navigator').setup()
    vim.keymap.set("n", "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" })
    vim.keymap.set("n", "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" })
    vim.keymap.set("n", "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" })
    vim.keymap.set("n", "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" })
  end
}
