{ pkgs, inputs, ... }:

let
  openrgb = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.openrgb;
  white = "FFFFFF";
in

{
  # nixpkgs' pinned openrgb is 1.0rc3, which reliably segfaults in
  # libstdc++ (confirmed via dmesg) when applying a mode/color to the
  # ASUS Aura USB motherboard device - `--list-devices` works fine,
  # only the apply path crashes. nixos-unstable already carries the
  # real 1.0 release; pulling just that package rather than moving the
  # whole system off the stable channel.
  home.packages = [ openrgb ];

  # Every cold `openrgb ...` CLI invocation re-scans I2C/HID/DRAM from
  # scratch (~5-6s) before doing anything - theme-switch.sh was chaining
  # 3 of those per theme switch. A long-running server detects hardware
  # once and then answers `openrgb --client ...` calls in ~1s, since
  # those skip detection entirely and just talk to the already-detected
  # device list.
  systemd.user.services.openrgb-server = {
    Unit = {
      Description = "OpenRGB SDK server";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${openrgb}/bin/openrgb --server";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Keeps case fans, mousepad, and the monitor's RGB pinned to white on every
  # boot/login, replacing the old theme-switch.sh keybind toggle. Deliberately
  # skips the Razer keyboard/mouse (routed through the monitor's KVM, but
  # still visible to OpenRGB as "Razer Huntsman Mini" / "Razer Deathadder V2
  # Mini") by targeting devices by name instead of applying to all. Polls for
  # the server's client port the same way theme-switch.sh used to, since the
  # server's hardware scan (~5-6s) isn't done just because systemd says it
  # started.
  systemd.user.services.openrgb-apply-color = {
    Unit = {
      Description = "Apply persistent white RGB color";
      After = [ "openrgb-server.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "openrgb-apply-color" ''
        set -euo pipefail

        for _ in $(seq 1 30); do
          if timeout 1 bash -c "echo >/dev/tcp/127.0.0.1/6742" 2>/dev/null; then
            break
          fi
          sleep 1
        done

        cmd=(${openrgb}/bin/openrgb --client 127.0.0.1:6742)
        # ASUS Aura USB's two case-fan zones default to 0 LEDs until sized -
        # see the matching comment that used to live in theme-switch.sh.
        "''${cmd[@]}" --device "ASUS" --zone 1 --size 16 --zone 2 --size 16 >/dev/null 2>&1 || true
        "''${cmd[@]}" --device "Goliathus" --mode direct --color ${white} --brightness 100 >/dev/null 2>&1 || true
        "''${cmd[@]}" --device "ASUS" --mode direct --color ${white} --brightness 100 >/dev/null 2>&1 || true
        "''${cmd[@]}" --device "MSI" --mode direct --color ${white} --brightness 100 >/dev/null 2>&1 || true
      ''}";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
