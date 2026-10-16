{ ... }:

{
  # GPG_TTY / SSH_AUTH_SOCK wiring for fish comes from
  # services.gpg-agent.enableFishIntegration (home/modules/gpg-agent.nix).
  programs.fish.enable = true;
}
