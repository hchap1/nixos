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

    quickCss = ''
      @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
    '';

    config = {
      useQuickCss = true;

      plugins = {
        # Keeps deleted/edited messages visible instead of silently vanishing.
        messageLogger.enable = true;
      };
    };
  };
}
