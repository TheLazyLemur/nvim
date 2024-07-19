local later = MiniDeps.later
local dap = require 'dap'
local dapui = require 'dapui'

later(function()
  vim.keymap.set("n", "<leader>jj", function() require("flash").jump() end)
  vim.keymap.set("n", "<leader>jt", function() require("flash").treesitter() end)

  vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<cr>")
  vim.keymap.set("n", "<leader>xb", ":Trouble diagnostics toggle filter.buf=0<cr>")

  vim.keymap.set("n", "<leader>tt", ":Neotree<cr>")

  vim.keymap.set("n", "<leader>bp", ":BufferLineTogglePin<cr>")
  vim.keymap.set("n", "<leader>bf", ":BufferLinePick<cr>")
  vim.keymap.set("n", "<leader>bq", ":BufferLinePickClose<cr>")
  vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<cr>")
  vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<cr>")

  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
end)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-plugins-lsp-attach", { clear = true }),
  pattern = "*.go",
  callback = function(event)
    vim.keymap.set("n", "<leader>tc", function() vim.cmd(":GoTestSubCase -v -F") end)
    vim.keymap.set("n", "<leader>tf", function() vim.cmd(":GoTestFunc -v -F") end)
    vim.keymap.set("n", "<leader>tt", function() vim.cmd(":GoTestFile -v -F") end)
    vim.keymap.set("n", "<leader>tp", function() vim.cmd(":GoTestPkg -v -F") end)
  end,
})
