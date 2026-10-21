{ pkgs, ... }:

let
  # Lunar Client's Microsoft-login popup is a secondary Electron
  # BrowserWindow; Chromium's native-Wayland Ozone backend has long-standing
  # bugs rendering/handling input on secondary popups (blank/unresponsive
  # window), which is what the broken login button almost always is. The
  # package's own wrapper opts into native Wayland (via --ozone-platform-hint
  # =auto) whenever NIXOS_OZONE_WL + WAYLAND_DISPLAY are set, which is always
  # true on this system - forcing just this app back through XWayland
  # sidesteps that bug while leaving every other Electron app native-Wayland.
  # An explicit --ozone-platform=x11 takes priority over the hint flag in
  # Chromium's own platform-selection logic regardless of argv order, so it
  # overrides rather than conflicts with the inner wrapper's flag.
  lunar-client-x11 = pkgs.symlinkJoin {
    name = "lunar-client-x11";
    paths = [ pkgs.lunar-client ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/lunarclient --add-flags "--ozone-platform=x11"
    '';
  };
in

{
  home.packages = [
    pkgs.modrinth-app
    lunar-client-x11
    # Mojang's official launcher was removed from nixpkgs (broken); this is
    # the recommended replacement and covers base/vanilla Minecraft fine.
    pkgs.prismlauncher
    # Hollow Knight mod manager (successor to the old "Scarab" name).
    pkgs.lumafly
  ];
}
