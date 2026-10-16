{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		neovim
			claude-code
			gh
			eza
			ripgrep
			bat
			git
	];

	programs.firefox.enable = true;
}
