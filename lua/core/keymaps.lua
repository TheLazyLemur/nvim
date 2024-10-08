local M = {}

local now = MiniDeps.now

now(function()
  vim.keymap.set("n", "<leader>cp", function()
    local absolute_path = vim.api.nvim_buf_get_name(0)
    local last_directory = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local relative_path = vim.fn.fnamemodify(absolute_path, ":.")
    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    vim.fn.setreg('+', last_directory .. "/" .. relative_path .. ":" .. line_number)
  end)

  vim.keymap.set("n", "<leader>z", MiniMisc.zoom)

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

  vim.keymap.set("t", "<C-space>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

  vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Exit terminal mode" })
  vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Exit terminal mode" })
  vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Exit terminal mode" })
  vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Exit terminal mode" })

  vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

  vim.keymap.set("n", "n", "nzzzv")
  vim.keymap.set("n", "N", "Nzzzv")

  vim.keymap.set('c', '<M-h>', '<Left>', { silent = false, desc = 'Left' })
  vim.keymap.set('c', '<M-l>', '<Right>', { silent = false, desc = 'Right' })

  vim.keymap.set('i', '<M-h>', '<Left>', { noremap = false, desc = 'Left' })
  vim.keymap.set('i', '<M-j>', '<Down>', { noremap = false, desc = 'Down' })
  vim.keymap.set('i', '<M-k>', '<Up>', { noremap = false, desc = 'Up' })
  vim.keymap.set('i', '<M-l>', '<Right>', { noremap = false, desc = 'Right' })

  vim.keymap.set('t', '<M-h>', '<Left>', { desc = 'Left' })
  vim.keymap.set('t', '<M-j>', '<Down>', { desc = 'Down' })
  vim.keymap.set('t', '<M-k>', '<Up>', { desc = 'Up' })
  vim.keymap.set('t', '<M-l>', '<Right>', { desc = 'Right' })

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

  require("mini.pick").setup()
  MODE = "telescope"
  TOGGLE_SEARCH_MODE = function()
    if MODE == "telescope" then
      MODE = "mini"
      return
    end

    if MODE == "mini" then
      MODE = "telescope"
      return
    end
  end

  local builtin = require "telescope.builtin"
  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  vim.keymap.set("n", "<leader>sf", function()
    if MODE == "telescope" then
      builtin.find_files()
    end
    if MODE == "mini" then
      vim.cmd("Pick files")
    end
  end, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
  vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
  vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "[/] Fuzzily search in current buffer" })

  vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = true,
      prompt_title = "Live Grep in Open Files",
    })
  end, { desc = "[S]earch [/] in Open Files" })
end)

M.lsp_maps = function(event)
  now(function()
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("<leader>gf", vim.lsp.buf.format, "")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
  end)
end

return M
