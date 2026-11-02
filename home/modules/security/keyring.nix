{ pkgs, ... }:

{
	# GUI front-end for the gnome-keyring secrets store enabled in
	# modules/security/keyring.nix - lets you inspect/add entries by hand.
	home.packages = [ pkgs.seahorse ];
}
