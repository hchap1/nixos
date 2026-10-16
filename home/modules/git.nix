{ ... }:

{
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "hc";
				email = "hchap1@hotmail.com";
			};
			pull.rebase = true;
			init.defaultBranch = "main";
			gpg.format = "openpgp";
		};

		signing = {
			key = "946DDA419949E2FE";
			signByDefault = true;
		};
	};
}
