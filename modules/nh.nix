{ config, ... }:

{
	programs.nh = {
		enable = true;
		clean.enable = true;
		flake = "/home/hc/nixos#${config.networking.hostName}";
	};
}
