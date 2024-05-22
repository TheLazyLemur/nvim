return {
  source = "nomnivore/ollama.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>oo", require("ollama").prompt)
    vim.keymap.set("v", "<leader>oo", require("ollama").prompt)
    vim.keymap.set("n", "<leader>oG", require("ollama").prompt)
    vim.keymap.set("v", "<leader>oG", require("ollama").prompt)
  end,
}
