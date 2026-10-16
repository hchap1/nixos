{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/nvidia.nix
    ./modules/hyprland.nix
    ./modules/sddm.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/maintenance.nix
    ./modules/users.nix
    ./modules/packages.nix
  ];

  networking.hostName = "battleship";
  system.stateVersion = "26.05";
}
