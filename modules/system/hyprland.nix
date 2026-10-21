{ ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # nixpkgs' hyprspace pin (2026-05-28) predates upstream's "Registering
  # Lua dispatchers" commit (58ab0722, 2026-07-07): it only registers
  # overview:toggle/open/close as classic string dispatchers, and
  # Lua-config Hyprland (see home/modules/hyprland/default.nix) has no
  # bridge from Lua back to that classic dispatcher table - only to
  # dispatchers with a native CA:: implementation - so those binds were
  # unreachable from home/hyprland/binds.lua. 58ab0722 instead calls
  # HyprlandAPI::addLuaFunction, exposing them as
  # hl.plugin.overview.toggle()/open()/close() directly, and its commit
  # message confirms it was tested against Hyprland 0.55.4 (our pinned
  # version). Pinned to that exact commit rather than current main:
  # later commits chase upstream header reorganizations (fullscreen
  # controller, MonitorState, AnimationManager moves) from a newer
  # Hyprland than 0.55.4 and fail to compile against it.
  nixpkgs.overlays = [
    (final: prev: {
      hyprlandPlugins = prev.hyprlandPlugins // {
        hyprspace = prev.hyprlandPlugins.hyprspace.overrideAttrs (old: {
          version = "0-unstable-2026-07-07";
          src = final.fetchFromGitHub {
            owner = "KZDKM";
            repo = "Hyprspace";
            rev = "58ab0722a4a9da65fc54a65709c3165220ffde86";
            hash = "sha256-O+/GVgrGmsMw9gkE/KEpXyG2nzZ7yd6qBv2yK5OdFP8=";
          };
          # Upstream always sizes a workspace's overview thumbnail to exactly
          # one monitor-width, so columns scrolled past the screen edge in a
          # scrolling layout got silently clipped out of SUPER+Tab. This
          # widens each thumbnail to its workspace's real rightmost window
          # edge instead - see the patch file for the full rationale.
          patches = (old.patches or [ ]) ++ [ ./patches/hyprspace-overview-fit.patch ];
        });
      };
    })
  ];
}
