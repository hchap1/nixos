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
      useQuickCss = true;
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];
      enabledThemeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];

      plugins = {
        # Keeps deleted/edited messages visible instead of silently vanishing.
        messageLogger.enable = true;
      };
    };
  };
}
