local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local plugins = {
  require("extra.plugins.trouble"),
  require("extra.plugins.flash"),
  require("extra.plugins.gonvim"),
  require("extra.plugins.debug"),
  require("extra.plugins.cloak"),
  require("extra.plugins.vimdadbod"),
  require("extra.plugins.supermaven"),
  require("extra.plugins.nui"),
  require("extra.plugins.neotree"),
  require("extra.plugins.colorschemes"),
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

require("extra.keymaps")
