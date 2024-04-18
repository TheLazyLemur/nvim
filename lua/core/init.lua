local S = {
  enabled = false
}

vim.cmd [[
  au BufNewFile,BufRead *.templ setfiletype templ
]]

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.laststatus = 3
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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

vim.keymap.set("n", "<F1>", function()
  if S.enabled then
    vim.cmd("tabdo windo set nonumber")
    S.enabled = false
    return
  end

  if not S.enabled then
    vim.cmd("tabdo windo set number")
    S.enabled = true
    return
  end
end)

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.opt.buftype:get() == "terminal" then
      vim.cmd(":startinsert")
    end
  end
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd("echo 'Installing `mini.nvim`' | redraw")
  local clone_cmd = {
    "git", "clone", "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim", mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd("echo 'Installed `mini.nvim`' | redraw")
end

require("mini.deps").setup({ path = { package = path_package } })

local add = MiniDeps.add

add("tpope/vim-sleuth")

add("lewis6991/gitsigns.nvim")
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

add({
  source = "stevearc/oil.nvim",
  depends = { "nvim-tree/nvim-web-devicons" },
})
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

add({
  source = "nvim-telescope/telescope.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons"
  },
  checkout = "0.1.x",
  monitor = "0.1.x",
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end
  },
})
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
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

vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files { cwd = vim.fn.stdpath "config" }
end, { desc = "[S]earch [N]eovim files" })

require("modules.bookmarks").setup()
vim.keymap.set("n", "<leader>ba", require("modules.bookmarks").bookmark_file)
vim.keymap.set("n", "<leader>bs", require("modules.bookmarks").show_selection_ui)

require("modules.findit").setup()
vim.keymap.set("n", "=sg", function() require("modules.findit").grep() end)
vim.keymap.set("n", "=sf", function() require("modules.findit").find_files() end)
vim.keymap.set("n", "=sff", function() require("modules.findit").find_files(true) end)

add({
  source = "neovim/nvim-lspconfig",
  depends = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "j-hui/fidget.nvim",
    "folke/neodev.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
})

require("neodev").setup()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("<leader>gf", vim.lsp.buf.format, "")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
}

require("mason").setup()

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua",
})
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

require("mason-lspconfig").setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
}

add({
  source = "hrsh7th/nvim-cmp",
  depends = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
  },
})

local cmp = require "cmp"
local luasnip = require "luasnip"
luasnip.config.setup {}
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = { completeopt = "menu,menuone,noinsert" },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping.confirm { select = true },
    ["<C-Space>"] = cmp.mapping.complete {},
    ["<C-l>"] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { "i", "s" }),
    ["<C-h>"] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
}

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "master",
  monitor = "main",
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vimdoc", "go", "markdown" },
  highlight = { enable = true },
})

add("folke/tokyonight.nvim")

if vim.fn.has("nvim-0.10") == 0 then
  vim.cmd.colorscheme "tokyonight-night"
  vim.cmd.hi "Comment gui=none"
  return
end

add({
  source = "folke/todo-comments.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
  },
})

require("todo-comments").setup({
  signs = false,
})

require("mini.ai").setup { n_lines = 500 }
require("mini.surround").setup()
local statusline = require "mini.statusline"
statusline.setup {
  set_vim_settings = false,
  use_icons = vim.g.have_nerd_font,
}
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

-- vim: ts=2 sts=2 sw=2 et
