{ pkgs, lib, ... }:

{
	programs.fish = {
		enable = true;

		shellInit = ''
			set -g fish_greeting
			set -gx LD_LIBRARY_PATH ${lib.makeLibraryPath [ pkgs.wayland pkgs.libxkbcommon pkgs.pipewire ]}:$LD_LIBRARY_PATH
			'';

		shellAliases = {
			ll = "eza -lah --icons";
			ls = "eza --icons";
			cat = "bat";
			ga = "git add";
			gc = "git commit";
			gp = "git push";
			pyshell = "nix develop /home/hc/nixos-config#python --command fish";
			rustshell = "nix develop /home/hc/nixos-config#rust --command fish";
		};
	};

	programs.zoxide = {
		enable = true;
		enableFishIntegration = true;
	};
}
