{ ... }:

{
  services.fstrim.enable = true;
  services.btrfs.autoScrub.enable = true;
  zramSwap.enable = true;
}
