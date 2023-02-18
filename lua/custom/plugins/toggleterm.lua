return {
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
}
