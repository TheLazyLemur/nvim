require("core.options")

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


local plugins = {
    require("core.plugins.vimsleuth"),
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

require('mini.misc').setup()
require("mini.bufremove").setup()
require("mini.tabline").setup({
    set_vim_settings = false,
})
require("mini.misc").setup()
require("mini.misc").setup_restore_cursor()
require("mini.comment").setup()

require("core.keymaps")
require("core.autocommands")
