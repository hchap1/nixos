{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (inputs.import-tree ./modules)
  ];

  networking.hostName = "battleship";
  system.stateVersion = "26.05";
}
