{ inputs, ... }:

{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;

    # Vesktop (Vencord's own Electron client) over stock Discord: it has a
    # native Wayland/PipeWire screen-share picker with audio support, which
    # plain Discord + injected Vencord does not get on Hyprland.
    discord.enable = false;
    vesktop = {
      enable = true;
      autoscroll.enable = true;
    };

    config = {
      # Theme is driven live by theme-switch.sh writing an @import into
      # quickCss.css instead of being fixed here - nixcord writes
      # settings.json as a nix-store symlink (not user-editable), but
      # quickCss.css is left as a regular file specifically for live
      # editing like this, so it survives theme switches without a
      # rebuild. See theme-switch.sh for the two theme URLs.
      useQuickCss = true;

      plugins = {
        # Keeps deleted/edited messages visible instead of silently vanishing.
        messageLogger.enable = true;
      };
    };
  };
}
