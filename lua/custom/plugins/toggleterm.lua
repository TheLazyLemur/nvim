return {
	"akinsho/toggleterm.nvim",
	config = function()
		require('toggleterm').setup {
			shade_terminals = false,
			direction = 'horizontal',
			size = 10,
			persist_size = false,
		}
	end,
}
