local function require_local(name)
    if package.searchpath(name, package.path) then
        require(name)
    end
end

hl.env("qsConfig", "floatg")

require("hyprland.env")
require_local("hyprland.scale")
require_local("hyprland.gpu")

require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

require_local("hyprland.monitors")
require_local("hyprland.workspaces")

local function enter_global_submap()
    hl.dispatch(hl.dsp.submap("global"))
end

hl.on("hyprland.start", function()
    enter_global_submap()
    hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)

hl.on("config.reloaded", enter_global_submap)
