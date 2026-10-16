{ inputs, ... }:

{
  home.username = "hc";
  home.homeDirectory = "/home/hc";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  imports = [ (inputs.import-tree ./modules) ];
}
