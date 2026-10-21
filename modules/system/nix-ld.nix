{ ... }:

{
  # NixOS has no FHS /lib64/ld-linux-x86-64.so.2 or standard shared-library
  # search path, which plain dynamically-linked binaries that aren't built
  # for Nix (self-extracting installers, bundled native helper tools some
  # mod loaders fetch and exec, etc.) assume exists. nix-ld installs a dummy
  # dynamic linker at that path and feeds it a sane library search path, so
  # those binaries "just work" the way they would on any other distro
  # instead of failing with "No such file or directory" despite the file
  # being right there.
  programs.nix-ld.enable = true;
}
