{ ... }:

{
	# Auto-unlock gpg-agent (and the SSH key it manages) with the SDDM login
	# password. SDDM's own PAM service substacks "login" for auth/session,
	# so this has to live on the "login" service, not "sddm" directly -
	# sddm.nix sets useDefaultRules = false and only forwards to "login".
	security.pam.services.login.gnupg = {
		enable = true;
		noAutostart = true; # gpg-agent is already started via home-manager's systemd user service
	};
}
