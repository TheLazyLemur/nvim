return {
  source = "nvim-neo-tree/neo-tree.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "akinsho/bufferline.nvim",
  },
  config = function()
    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    })

    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        custom_filter = function(buf, buf_nums)
          if vim.bo[buf].filetype == " " or vim.bo[buf].filetype == "" or vim.bo[buf].buftype == "terminal" then
            return false
          end
          return true
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      }
    })
  end
}
