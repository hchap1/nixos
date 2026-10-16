{ ... }:

{
  # Compositor is launched via UWSM; the actual hyprland.lua config is owned
  # by home-manager (see home/modules/hyprland/default.nix).
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
