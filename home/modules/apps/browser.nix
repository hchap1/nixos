{ pkgs, ... }:

{
  home.packages = [
    # Tailscale/ZeroTier interfaces otherwise get offered as WebRTC ICE
    # candidates, hanging Discord calls (and other WebRTC sites) on "DTLS
    # Connecting" - same issue and fix as vesktop in nixcord.nix.
    ((pkgs.vivaldi.override {
      commandLineArgs = "--force-webrtc-ip-handling-policy=default_public_interface_only";
    }).overrideAttrs (old: {
      # __GL_THREADED_OPTIMIZATIONS=0 works around NVIDIA's threaded GL
      # optimizations racing on Onshape's WebGL context churn (see
      # modules/graphics/nvidia.nix), but it used to be set session-wide,
      # which made Brave's PDF viewer painfully laggy - PDF scroll
      # continuously rasterizes/uploads page textures, so forcing
      # single-threaded GL dispatch hits it far harder than normal page
      # scrolling. Scoped to just Vivaldi here instead.
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/vivaldi --set __GL_THREADED_OPTIMIZATIONS 0
      '';
    }))
    pkgs.vivaldi-ffmpeg-codecs
    pkgs.brave
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
