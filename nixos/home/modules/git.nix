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
    };
  };
}
