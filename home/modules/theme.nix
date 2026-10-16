{ pkgs, ... }:

let
  variant = "mocha";
  accent = "mauve";
in

{
  # Shared Catppuccin Mocha theming for GTK and Qt apps, so anything that
  # doesn't ship its own theme (file manager, chat clients, etc.) still
  # matches the rest of the system instead of falling back to defaults.
  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-${variant}-${accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        inherit variant;
        accents = [ accent ];
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = variant;
        inherit accent;
      };
    };

    cursorTheme = {
      name = "catppuccin-${variant}-${accent}-cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 24;
    };
  };

  # Qt apps (Dolphin) don't follow GTK themes directly: qt6ct/qt5ct supply
  # the palette and Kvantum supplies the widget style.
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";

    qt5ctSettings.Appearance = {
      style = "kvantum";
      icon_theme = "Papirus-Dark";
      custom_palette = true;
      color_scheme_path = "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/catppuccin-${variant}-${accent}.conf";
      standard_dialogs = "xdgdesktopportal";
    };

    qt6ctSettings.Appearance = {
      style = "kvantum";
      icon_theme = "Papirus-Dark";
      custom_palette = true;
      color_scheme_path = "${pkgs.catppuccin-qt5ct}/share/qt6ct/colors/catppuccin-${variant}-${accent}.conf";
      standard_dialogs = "xdgdesktopportal";
    };
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=catppuccin-${variant}-${accent}
  '';

  home.packages = [
    (pkgs.catppuccin-kvantum.override { inherit variant accent; })
  ];
}
