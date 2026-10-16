{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    claude-code
    gh
  ];

  programs.firefox.enable = true;
}
