local later = MiniDeps.later
local dap = require 'dap'
local dapui = require 'dapui'

later(function()
  vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<cr>")
  vim.keymap.set("n", "<leader>xb", ":Trouble diagnostics toggle filter.buf=0<cr>")

  vim.keymap.set('n', '<F5>', dap.continue)
  vim.keymap.set('n', '<F1>', dap.step_into)
  vim.keymap.set('n', '<F2>', dap.step_over)
  vim.keymap.set('n', '<F3>', dap.step_out)
  vim.keymap.set('n', '<F7>', dapui.toggle)

  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })
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
