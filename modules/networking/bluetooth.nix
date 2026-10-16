{ pkgs, ... }:

{
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;
	services.blueman.enable = true; # blueman-applet should be managed by niri
}
