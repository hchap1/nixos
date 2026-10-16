{ inputs, config, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  # Real file in the repo (home/noctalia/config.toml), symlinked out of the
  # store, same reasoning as hyprland.lua: `noctalia msg ...` persists
  # changes (theme, wallpaper, bar state) straight back into this file, and
  # that needs it to be a writable path, not a store-backed one. `settings`
  # is left unset on programs.noctalia above so the module never contends
  # for this same path.
  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/noctalia/config.toml";
}
