require("core.options")

local mini_indentscope = require("mini.indentscope")
mini_indentscope.setup()

local mini_misc = require("mini.misc")
mini_misc.setup()
mini_misc.setup_restore_cursor()
mini_misc.setup_termbg_sync()

local mini_comment = require("mini.comment")
mini_comment.setup()

local mini_icons = require("mini.icons")
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local plugins = {
    require("core.plugins.vimsleuth"),
    require("core.plugins.nvimtree"),
    require("core.plugins.gitsigns"),
    require("core.plugins.treesitter"),
    require("core.plugins.lsp"),
    require("core.plugins.oil"),
    require("core.plugins.telescope"),
    require("core.plugins.multic"),
}

for _, plugin in ipairs(plugins) do
    add({
        source = plugin.source,
        depends = plugin.depends,
    })
    if plugin.lazy then
        later(function() pcall(plugin.config) end)
    else
        now(function() pcall(plugin.config) end)
    end
end

require('core.statusline')

require("core.keymaps")
require("core.autocommands")
