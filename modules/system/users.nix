{ pkgs, ... }:

{
  users.users.hc = {
    isNormalUser = true;
    description = "hc";
    extraGroups = [ "wheel" "networkManager" "video" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
