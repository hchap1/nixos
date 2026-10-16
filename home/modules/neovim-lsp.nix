{ pkgs, ... }:

{
  # lua/plugins/lsp.lua in ~/.config/nvim disables mason entirely when it
  # detects Nix (IS_NIX) and just calls vim.lsp.enable() expecting these on
  # PATH already - so on this machine, this list *is* the install step.
  home.packages = with pkgs; [
    lua-language-server # lua_ls
    tinymist # tinymist (Typst)
    nil # nil_ls (Nix)
    sqls
    ty
    rust-analyzer # used by rustaceanvim
  ];
}
