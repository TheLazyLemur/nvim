return {
  source = "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      shade_terminals = false,
      size = 20
    })

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit  = Terminal:new({ hidden = true, height = 50 })

    local function _toggle()
      lazygit:toggle()
    end

    vim.keymap.set("n", "=tt", _toggle, { noremap = true, silent = true })
    vim.keymap.set("t", "=tt", _toggle, { noremap = true, silent = true })
  end
}
