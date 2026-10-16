{ pkgs, ... }:

{
  home.packages = [
    pkgs.modrinth-app
    pkgs.lunar-client
    # Mojang's official launcher was removed from nixpkgs (broken); this is
    # the recommended replacement and covers base/vanilla Minecraft fine.
    pkgs.prismlauncher
  ];
}
