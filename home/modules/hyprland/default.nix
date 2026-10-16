{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    # Installed system-wide by `programs.hyprland` (modules/hyprland.nix);
    # don't build a second copy here.
    package = null;
    portalPackage = null;

    # UWSM owns the session lifecycle, so hyprland-session.target is unused.
    systemd.enable = false;

    # Actual config is real Lua, written in ../../hyprland/, not the Nix
    # settings DSL. This home-manager version has no extraLuaFiles option
    # (it postdates this pin), so the files' text is read straight into
    # extraConfig, which is appended verbatim to hyprland.lua.
    extraConfig = builtins.concatStringsSep "\n" [
      (builtins.readFile ../../hyprland/monitors.lua)
      (builtins.readFile ../../hyprland/binds.lua)
    ];
  };
}
