local S = {}

local function is_buffer_valid(buf_id)
	return vim.api.nvim_buf_is_valid(buf_id)
end

function S.thing(term)
	if S[term] == nil then
		S.open()
		return
	end

	if not is_buffer_valid(S[term]) then
		S.open()
		return
	end

	local width = 100
	local height = math.min(30, 30)

	if height < 10 then
		height = 10
	end

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local _ = vim.api.nvim_open_win(S[term], true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
		title = "Terminal",
		title_pos = "center",
	})

	vim.cmd("startinsert")
end

function S.open_split(term)
	if term == nil then
		term = "default"
	end
	vim.api.nvim_command('vsplit')
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, S[term])
	vim.cmd("startinsert")
end

function S.open_h_split(term)
	if term == nil then
		term = "default"
	end
	vim.api.nvim_command('split')
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, S[term])
	vim.cmd("startinsert")
end

function S.open(term)
	if term == nil then
		term = "default"
	end

	if S[term] ~= nil and is_buffer_valid(S[term]) then
		S.thing(term)
		return
	end

	S[term] = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("modifiable", true, { buf = S[term] })

	local width = 100
	local height = math.min(30, 30)

	if height < 10 then
		height = 10
	end

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local _ = vim.api.nvim_open_win(S[term], true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
		title = "Terminal",
		title_pos = "center",
	})

	vim.cmd("terminal")
	vim.cmd("startinsert")

	vim.keymap.set("t", "<Esc><Esc>", function()
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_close(win, true)
	end, { buffer = S[term] })

	vim.keymap.set("n", "<Esc><Esc>", function()
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_close(win, true)
	end, { buffer = S[term] })
end

return S
