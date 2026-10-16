{ inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;

    # Starts noctalia as a systemd --user service tied to the Wayland
    # session target, instead of an exec-once line in hyprland.lua.
    systemd.enable = true;

    # `settings` is intentionally left unset (default {}). Setting it would
    # make home-manager generate and manage ~/.config/noctalia/config.toml,
    # which gets regenerated (and the live file backed up/clobbered) on
    # every `nixos-rebuild switch`. Leaving it unset means home-manager never
    # touches that file at all, so edits made in noctalia's own settings GUI
    # persist across rebuilds.
  };
}
