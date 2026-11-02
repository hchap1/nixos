{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-tty;
    # gpg-agent has no literal "never expire" - pinning both the idle and
    # max TTLs to ~68 years (2^31-1s) is the standard way to get that in
    # practice, so the pam_gnupg preset below never silently falls out of
    # cache and re-prompts.
    defaultCacheTtl = 2147483647;
    maxCacheTtl = 2147483647;
    defaultCacheTtlSsh = 2147483647;
    maxCacheTtlSsh = 2147483647;
    # required for pam_gnupg (modules/system/gnupg-pam.nix) to preset the
    # passphrase into the agent's cache at SDDM login time
    extraConfig = "allow-preset-passphrase";
  };

  # keygrips pam_gnupg should unlock at login - see modules/system/gnupg-pam.nix.
  # Primary signing key + the ssh key's cache id (`gpg -K --with-keygrip` /
  # `gpg-connect-agent 'KEYINFO --ssh-list' /bye`). Not secret, just identifiers.
  home.file.".pam-gnupg".text = ''
    0BDF267C4F348C83990F24C2CAD181A4ECFE210F
    C8C0F0A5601F7FB36931A635E8310553242A0403
  '';
}
