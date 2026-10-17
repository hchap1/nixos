{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in

{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
    ];
  };

  # theme-switch.sh runs `spicetify config color_scheme ... && spicetify
  # apply` to flip between catppuccin's own schemes live (mocha for the
  # Catppuccin side, frappe - the warmest/least blue of the dark ones -
  # as a Gruvbox approximation; catppuccin has no actual gruvbox scheme).
  # Not in PATH by default since spicetify-nix applies the theme itself
  # at rebuild time without expecting the CLI to be run by hand.
  home.packages = [ pkgs.spicetify-cli ];
}
