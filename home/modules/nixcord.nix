{ inputs, pkgs, ... }:

let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};

  # Vesktop bundles its own copy of Vencord's patcher, built separately
  # from (and *not* kept in lockstep with) the Vesktop app version -
  # bumping Vesktop alone does nothing. Discord migrated their build
  # tooling to rspack in early November 2026, which broke Vencord
  # <1.15.16's WebpackPatcher pattern matching against Discord's live web
  # client ("i.A is not a constructor" in chrome devtools, #app-mount
  # left empty - a blank window with no visible error). Confirmed via
  # the upstream Vesktop maintainer (github.com/Vencord/Vesktop/issues/1392)
  # and matching nixpkgs PR #584169 bumping nixpkgs' separate `vencord`
  # package past this exact break. nixpkgs' `vencord` is still on 1.15.13
  # as of this writing, and that PR isn't merged - so pulling v1.15.16
  # straight from upstream and building vesktop with withSystemVencord
  # instead of its own bundled copy. Drop this override once nixpkgs'
  # `vencord` catches up to >=1.15.16.
  vencordFixed = unstablePkgs.vencord.overrideAttrs (old: {
    version = "1.15.16";
    src = unstablePkgs.fetchFromGitHub {
      owner = "Vendicated";
      repo = "Vencord";
      tag = "v1.15.16";
      hash = "sha256-aUJubLJpyLAZWiOezqFxPY6oVPgWVPQpajFqrJvrO9U=";
    };
    # The 18.3.1->19.1.0 @types/react patch/postPatch no longer applies -
    # upstream switched to a pnpm catalog reference (already 19.2.3 in
    # the lockfile) by 1.15.16.
    patches = [ ];
    postPatch = "";
    pnpmDeps = unstablePkgs.fetchPnpmDeps {
      pname = old.pname;
      src = unstablePkgs.fetchFromGitHub {
        owner = "Vendicated";
        repo = "Vencord";
        tag = "v1.15.16";
        hash = "sha256-aUJubLJpyLAZWiOezqFxPY6oVPgWVPQpajFqrJvrO9U=";
      };
      patches = [ ];
      postPatch = "";
      pnpm = unstablePkgs.pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-HS8uZNepvDefjrsG3buVLFCVv7sHvazcwdpcT3EQ/78=";
    };
  });

  vesktopUnstable = unstablePkgs.vesktop.override {
    vencord = vencordFixed;
    withSystemVencord = true;
  };
in

{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;

    # Vesktop (Vencord's own Electron client) over stock Discord: it has a
    # native Wayland/PipeWire screen-share picker with audio support, which
    # plain Discord + injected Vencord does not get on Hyprland.
    discord.enable = false;
    vesktop = {
      enable = true;
      autoscroll.enable = true;

      # Tailscale (and ZeroTier) hand this host an interface with its own
      # address, which Chromium's WebRTC happily offers as an ICE candidate
      # even though it can't reach Discord's voice servers - voice calls
      # hang on "DTLS Connecting" while that candidate is tried. Restrict
      # ICE gathering to the interface that owns the default route instead.
      package = vesktopUnstable.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/vesktop \
            --add-flags "--force-webrtc-ip-handling-policy=default_public_interface_only"
        '';
      });
    };

    quickCss = ''
      @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
    '';

    config = {
      useQuickCss = true;

      plugins = {
        # Keeps deleted/edited messages visible instead of silently vanishing.
        messageLogger.enable = true;
      };
    };
  };
}
