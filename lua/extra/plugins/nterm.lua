return {
  source = "TheLazyLemur/nterm.nvim",
  config = function()
    require("nterm").setup()
    vim.keymap.set("n", "==<space>", require("nterm").toggle_terminal)
    vim.keymap.set("t", "==<space>", require("nterm").toggle_terminal)
    for i = 1, 5, 1 do
      vim.keymap.set("n", "==" .. i, function() require("nterm").toggle_terminal(i) end)
      vim.keymap.set("t", "==" .. i, function() require("nterm").toggle_terminal(i) end)
    end
  end
}
