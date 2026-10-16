{ pkgs, ... }:

{
  home.packages = [
    pkgs.slack
    # GTK4/libadwaita WhatsApp client; follows the Catppuccin GTK theme from
    # ../theme.nix instead of shipping its own look.
    pkgs.karere
  ];
}
