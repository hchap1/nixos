{ config, pkgs, ... }:

{
  # The plain in-tree hid_logitech driver's device table doesn't include the
  # G923's USB ID (046D:C267) at all - confirmed live on this machine, it
  # falls back to hid-generic, which gets you basic axes/buttons but no
  # force feedback and no mode-switch into the wheel's native/advanced PID
  # (046D:C266). new-lg4ff is the community driver that actually knows this
  # wheel; blacklisting the stock driver stops it grabbing the device first.
  boot.extraModulePackages = [ config.boot.kernelPackages.new-lg4ff ];
  boot.blacklistedKernelModules = [ "hid_logitech" ];
  boot.kernelModules = [ "hid_logitech_new" ];

  # GUI for setting wheel range/FFB gain/combine-pedals etc. per game -
  # useful since Forza (via Proton) has no in-game wheel-range setting of
  # its own.
  environment.systemPackages = [ pkgs.oversteer ];
}
