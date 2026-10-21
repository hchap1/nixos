{ pkgs, ... }:

{
  home.packages = [
    pkgs.vivaldi
    pkgs.vivaldi-ffmpeg-codecs
  ];

  # No default browser is registered on a fresh NixOS install. Electron/Tauri
  # apps don't open a browser window themselves for OAuth-style logins (Lunar
  # Client, Discord, etc.) - they shell out to xdg-open, which silently does
  # nothing if nothing is registered for http(s)/html. That's the "the login
  # button doesn't do anything" symptom - this fixes it at the source instead
  # of per-app.
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "vivaldi-stable.desktop" ];
    "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
    "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
  };
}
