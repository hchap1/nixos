{ config, lib, ... }:

let
  # Nix path literals (./foo, ../bar) resolve against the flake's frozen
  # store copy, not the live working directory - so they'd silently point
  # these symlinks at an immutable snapshot that only updates on rebuild.
  # Hardcoding the real on-disk path is what makes edits here take effect
  # on an hyprctl reload instead of a nixos-rebuild.
  hyprDir = "${config.home.homeDirectory}/nixos/home/hyprland";
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
in
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
  };

  xdg.configFile = {
    # Overrides the module's own generated hyprland.lua (same priority by
    # default - mkForce makes ours win instead of a conflicting-definitions
    # eval error).
    "hypr/hyprland.lua".source = lib.mkForce (outOfStore "${hyprDir}/hyprland.lua");

    # Hyprland resolves require() relative to wherever hyprland.lua itself
    # lives, so these need to be real files (symlinks are fine) right next
    # to it in ~/.config/hypr, not just present somewhere in the repo.
    "hypr/monitors.lua".source = outOfStore "${hyprDir}/monitors.lua";
    "hypr/binds.lua".source = outOfStore "${hyprDir}/binds.lua";
  };
}
