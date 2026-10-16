{ ... }:

{
  home.username = "hc";
  home.homeDirectory = "/home/hc";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  imports = [
    ./modules/git.nix
    ./modules/ghostty.nix
    ./modules/hyprland/default.nix
  ];
}
