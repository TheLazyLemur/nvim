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

add({
  source = "nvim-telescope/telescope.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons"
  },
  version = false,
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

pcall(require("telescope").load_extension, "ui-select")

add({
  source = "neovim/nvim-lspconfig",
  depends = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/neodev.nvim",
  },
})

require("neodev").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
}

local lsp_configs = require("lspconfig")
lsp_configs.gleam.setup {
  cmd = { "gleam", "lsp" },
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
      -- if server_name == "gopls" then
      --   server.cmd = { "gopls", "-remote=:37374", "-logfile=auto", "-debug=:0", "-rpc.trace" }
      -- end
      if server_name == "gopls" then
        server.cmd = { "gopls" }
        -- FIXME: workaround for https://github.com/neovim/neovim/issues/28058
        server.workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
            relativePatternSupport = false,
          },
        }
        server.root_dir = function() return vim.fs.dirname(vim.fs.find({ "go.mod" }, { upward = true })[1]) end
      end
      require("lspconfig")[server_name].setup(server)
    end,
  },
}

require('mini.completion').setup()

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

local statusline = require "mini.statusline"
statusline.setup {
  set_vim_settings = false,
  use_icons = vim.g.have_nerd_font,
}
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

require('mini.misc').setup()
require("mini.bufremove").setup()
require("mini.tabline").setup()
require("mini.misc").setup()
require("mini.misc").setup_restore_cursor()
require("mini.comment").setup()
