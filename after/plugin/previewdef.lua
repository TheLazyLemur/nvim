vim.cmd [[
	nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
	nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
	nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
	nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
	nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
]]
