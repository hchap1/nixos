{ pkgs, ... }:

{
  # Dolphin: closest Linux equivalent to Windows Explorer's feature set
  # (tree-view sidebar, detailed list columns, split view, previews), and
  # picks up the Catppuccin Kvantum/qt6ct theme from ../theme.nix.
  home.packages = with pkgs.kdePackages; [
    dolphin
    dolphin-plugins
    kio-extras
    ark
    ffmpegthumbs
    kdegraphics-thumbnailers
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "org.kde.dolphin.desktop" ];
  };
}
