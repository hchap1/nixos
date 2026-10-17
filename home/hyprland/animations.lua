-- easeOutExpo-ish: snappy deceleration, no overshoot.
hl.curve("fluidOut", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
-- easeInOutCubic-ish: smooth both ends, good for symmetric motion.
hl.curve("fluidInOut", { type = "bezier", points = { {0.65, 0}, {0.35, 1} } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "fluidOut", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "fluidOut", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "fluidOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "fluidInOut" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "fluidOut" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "fluidInOut" })
hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "fluidOut", style = "slide" })

-- Clean vertical scroll between workspaces. binds.lua chains rapid
-- repeated j/k presses into sequential same-speed hops (one every
-- WORKSPACE_ANIM_MS, which must match speed*100 here) rather than firing
-- independent/overlapping animations - that's what actually fixes the
-- "second hop looks faster/slower" problem, not the curve shape. It also
-- temporarily swaps style to "fade" for SUPER+<number> jumps - see
-- focusWorkspaceByNumber in binds.lua.
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "fluidInOut", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.5, bezier = "fluidInOut", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.5, bezier = "fluidInOut", style = "slidevert" })
