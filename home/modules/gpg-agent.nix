{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-tty;
    defaultCacheTtl = 43200; # 12h, matches the ssh ttl below
    maxCacheTtl = 43200;
    defaultCacheTtlSsh = 43200; # 12h
    maxCacheTtlSsh = 43200;
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
