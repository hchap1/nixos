{ config, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  # Whole ~/.config/hypr is one out-of-store symlink to this directory, not a
  # per-file one - new .lua files just work via require() with no rebuild,
  # since Nix never reads this directory's contents (plain string, not a
  # path literal).
  xdg.configFile."hypr".source =
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/hyprland");
}
