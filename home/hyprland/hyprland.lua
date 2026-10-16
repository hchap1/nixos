hl.plugin.load(os.getenv("HYPRSPACE_PLUGIN"))

require("monitors")
require("binds")
require("animations")
require("rules")
require("appearance")

hl.config({ input = { follow_mouse = 0 } })
