{ pkgs, inputs, ... }:

let
  openrgb = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.openrgb;
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
}
