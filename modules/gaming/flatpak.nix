{ pkgs, ... }:

{
  services.flatpak.enable = true;

  # services.flatpak doesn't add any remotes on its own; add Flathub so
  # `flatpak install flathub ...` (e.g. Sober) works without a manual step.
  systemd.services.flatpak-add-flathub-repo = {
    wantedBy = [ "multi-user.target" ];
    after = [ "flatpak-system-helper.service" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
    serviceConfig.Type = "oneshot";
  };
}
