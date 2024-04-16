local add = MiniDeps.add

local plugins = {
  require("extra.plugins.trouble"),
  require("extra.plugins.neotest"),
}

for _, plugin in ipairs(plugins) do
  add({
    source = plugin.source,
    depends = plugin.depends,
  })

  if plugin.config ~= nil then
    if plugin.lazy then
      MiniDeps.later(plugin.config)
    else
      MiniDeps.now(plugin.config)
    end
  end
end
