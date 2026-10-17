{ pkgs, lib, ... }:

{
  # ~/.claude/settings.json is mutable app state - Claude Code itself
  # writes to it at runtime (theme switches, model picks, the auto-mode
  # opt-in dialog, etc.), so it can't be a home-manager symlink without
  # breaking those writes. Instead, merge just the one key we care about
  # into whatever's there on every activation - idempotent, and leaves
  # every other runtime-written key alone.
  home.activation.claudeAutoMode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settingsFile="$HOME/.claude/settings.json"
    mkdir -p "$(dirname "$settingsFile")"
    if [ ! -e "$settingsFile" ]; then
      echo '{}' > "$settingsFile"
    fi
    merged="$(${pkgs.jq}/bin/jq '.permissions.defaultMode = "auto"' "$settingsFile")"
    echo "$merged" > "$settingsFile"
  '';
}
