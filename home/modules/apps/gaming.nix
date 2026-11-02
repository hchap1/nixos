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

  # nixpkgs' modrinth-app wrapper --sets LD_LIBRARY_PATH for the game JVM to a
  # hardcoded, X11-only library list (libGL plus libX11/Xcursor/Xext/Xrandr/
  # Xxf86vm). That was fine while GLFW probed backends in turn, but Minecraft
  # 26.2 ships LWJGL 3.4.1 / GLFW 3.4, and GLFW 3.4 consults XDG_SESSION_TYPE
  # during platform selection: on a Wayland session it *commits* to the
  # Wayland backend instead of falling through to X11. With no
  # libwayland-client on the path, glfwInit() then fails outright with
  #   [0x10008] Wayland: Failed to load libwayland-client
  # rather than quietly landing on XWayland.
  #
  # The resulting crash names neither Wayland nor the launcher. PackCore (the
  # SkyBlock Enhanced config-pack mod) calls glfwInit() early to read the
  # monitor size, logs "GLFW init failed, using fallback resolution", then
  # probes glfwGetPrimaryMonitor() anyway - which queues a *thread-local*
  # GLFW_NOT_INITIALIZED on the main thread. Minecraft renames that very
  # thread to "Render thread", and its checkGlfwError() guard that runs just
  # before its own glfwInit() finds the stale error and aborts with
  #   IllegalStateException: GLFW error before init: [0x10001]
  #
  # The library list is not a derivation argument, and the wrapper --sets
  # rather than --prefixes LD_LIBRARY_PATH, so wrapping it again from the
  # outside cannot extend the path - the inner wrapper would just overwrite
  # it. Pass the extra libraries in through libGL instead, which the
  # derivation feeds straight into lib.makeLibraryPath.
  modrinth-app-wayland = pkgs.modrinth-app.override {
    libGL = pkgs.symlinkJoin {
      name = "modrinth-glfw-runtime-libs";
      paths = with pkgs; [
        libGL
        wayland # libwayland-client/-cursor/-egl
        libxkbcommon # GLFW's Wayland keymap handling
        libdecor # client-side window decorations
        # GLFW's X11 backend dlopens these as well; they are absent from the
        # upstream list too, so include them to keep the XWayland path intact
        # should XDG_SESSION_TYPE ever be x11.
        libxi
        libxinerama
        libxrender
      ];
    };
  };
in

{
  home.packages = [
    modrinth-app-wayland
    lunar-client-x11
    # Mojang's official launcher was removed from nixpkgs (broken); this is
    # the recommended replacement and covers base/vanilla Minecraft fine.
    pkgs.prismlauncher
    # Hollow Knight mod manager (successor to the old "Scarab" name).
    pkgs.lumafly
  ];
}
