return function(use)
	use({
		"ggandor/lightspeed.nvim",
		config = function()
			require("lightspeed").setup({})
		end,
	})

	use({
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({
				global_settings = {
					save_on_toggle = false,
					save_on_change = true,
					enter_on_sendcmd = false,
					tmux_autoclose_windows = false,
					excluded_filetypes = { "harpoon" },
					mark_branch = true,
				}
			})
		end,
	})

	use({
		"Exafunction/codeium.vim",
		config = function ()
		end
	})

	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require('toggleterm').setup {
				direction = 'float',
				persist_size = false,
				float_opts = {
					border = 'curved'
				}

			}
		end,
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup ({})
		end,
	})

	use({
		"nvim-tree/nvim-web-devicons"
	})

	use({
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup ({})
		end,
	})
end
