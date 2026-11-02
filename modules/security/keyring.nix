{ ... }:

{
	# Secret Service provider (freedesktop libsecret backend) for apps like
	# Mailbird to store saved passwords. Enabling this also sets
	# security.pam.services.login.enableGnomeKeyring = true, so the keyring
	# auto-unlocks with the SDDM login password - same "login" PAM service
	# gnupg-pam.nix hooks for gpg-agent.
	services.gnome.gnome-keyring.enable = true;
}
