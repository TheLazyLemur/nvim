local function mc_statusline()
    local mc = require("multicursor-nvim")
    local status = {}
    if mc.hasCursors() then
        status.enabled = true
        if vim.fn.mode() == "v" then
            status.icon = "󰚕 "
            status.short_text = "V"
            status.text = "VISUAL"
            status.color = "lualine_a_visual"
        else
            status.icon = "󰬸 "
            status.short_text = "N"
            status.text = "MULTI"
            status.color = "lualine_a_normal"
        end
    else
        status.enabled = false
        status.icon = "󰘪 "
        status.short_text = "NO"
        status.text = "NO_MULTI"
        status.color = "lualine_a_normal"
    end
    status.icon_short_text = status.icon .. status.short_text
    status.icon_text = status.icon .. status.text
    return status
end

local statusline = require "mini.statusline"
statusline.setup {
    set_vim_settings = true,
    use_icons = true,
    content = {
        active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 40 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
            local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location      = MiniStatusline.section_location({ trunc_width = 75 })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                 strings = { mode, mc_statusline().icon_text } },
                { hl = 'MiniStatuslineDevinfo', strings = { git, diff, lsp } },
                '%<', -- Mark general truncate point
                { hl = 'MiniStatuslineFilename', strings = { filename } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                { hl = mode_hl,                  strings = { search, location } },
            })
        end,
        inactive = nil,
    },
}
statusline.section_location = function()
    return "%2l:%-2v"
end
