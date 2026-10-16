{ pkgs, ... }:

{
  home.packages = [ pkgs.devenv ];

  # Auto-activates a project's devenv.nix via .envrc ("use devenv") when you
  # cd into it, and tears it down when you leave. nix-direnv caches the
  # built environment so re-entering a directory is instant instead of
  # re-running the Nix evaluation every time.
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
