require("core")
require("extra")

vim.keymap.set("n", "==", function() require("modules.terminal").open() end)
vim.keymap.set("n", "=s", function() require("modules.terminal").open_h_split() end)
