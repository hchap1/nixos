{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  # The module always wants to write its own generated hyprland.lua whenever
  # configType is "lua", regardless of plugins/settings/extraConfig being
  # empty. That collides with the whole-directory symlink below: once a
  # sibling activation entry resolves through ~/.config/hypr (itself a
  # symlink), the nested path lands outside the expected tree and the
  # installer errors out. Disabling it outright is what actually avoids
  # that - overriding its .source doesn't, since both entries still get
  # processed independently.
  xdg.configFile."hypr/hyprland.lua".enable = lib.mkForce false;

  xdg.configFile."hypr".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/hyprland";

  # Plugin .so path, read by hl.plugin.load() in hyprland.lua. An env var
  # sidesteps the same nested-path problem a Nix-managed file would hit.
  home.sessionVariables.HYPRSPACE_PLUGIN = "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so";

  # Screenshot binds in binds.lua (SUPER+SHIFT+S / SUPER+CTRL+SHIFT+S) shell
  # out to screenshot.sh, which needs these directly (dropped grimblast -
  # see screenshot.sh for why).
  home.packages = [ pkgs.grim pkgs.slurp pkgs.wl-clipboard pkgs.libnotify ];
}
