{ lib, ... }:

let
  inline = lib.generators.mkLuaInline;

  # SUPER + [0-9] focuses a workspace, SUPER + SHIFT + [0-9] moves the active
  # window to it. 10 is bound to the "0" key, matching Hyprland's own example.
  workspaceBinds = builtins.concatMap (i:
    let key = if i == 10 then "0" else toString i;
    in [
      {
        _args = [
          (inline ''mod .. " + ${key}"'')
          (inline "hl.dsp.focus({ workspace = ${toString i} })")
        ];
      }
      {
        _args = [
          (inline ''mod .. " + SHIFT + ${key}"'')
          (inline "hl.dsp.window.move({ workspace = ${toString i} })")
        ];
      }
    ]
  ) (lib.range 1 10);
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    # Installed system-wide by `programs.hyprland` (modules/hyprland.nix);
    # don't build a second copy here.
    package = null;
    portalPackage = null;

    # UWSM owns the session lifecycle, so hyprland-session.target is unused.
    systemd.enable = false;

    settings = {
      mod = {
        _var = "SUPER";
      };

      terminal = {
        _var = "ghostty";
      };

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };

      bind = [
        {
          _args = [
            (inline ''mod .. " + RETURN"'')
            (inline "hl.dsp.exec_cmd(terminal)")
          ];
        }
        {
          _args = [
            (inline ''mod .. " + Q"'')
            (inline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            (inline ''mod .. " + SHIFT + E"'')
            (inline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            (inline ''mod .. " + V"'')
            (inline ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }
      ] ++ workspaceBinds;
    };
  };
}
