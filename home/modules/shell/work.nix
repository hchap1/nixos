{ pkgs, ... }:

{
	home.packages = [ pkgs.awscli2 ];

	# Isolate ~/work: separate Claude Code account (own CLAUDE_CONFIG_DIR, so
	# logging in there doesn't touch the main account) and separate AWS IAM
	# identity (own config/credentials files, log in later with `aws configure`
	# or `aws configure sso`).
	programs.fish.shellInit = ''
		function __hc_work_env --on-variable PWD
			if test "$PWD" = "$HOME/work"; or string match -q "$HOME/work/*" -- "$PWD"
				mkdir -p "$HOME/work/.claude" "$HOME/work/.aws"
				chmod 700 "$HOME/work/.aws"
				set -gx CLAUDE_CONFIG_DIR "$HOME/work/.claude"
				set -gx AWS_CONFIG_FILE "$HOME/work/.aws/config"
				set -gx AWS_SHARED_CREDENTIALS_FILE "$HOME/work/.aws/credentials"
			else
				set -e CLAUDE_CONFIG_DIR
				set -e AWS_CONFIG_FILE
				set -e AWS_SHARED_CREDENTIALS_FILE
			end
		end
		__hc_work_env
	'';
}
