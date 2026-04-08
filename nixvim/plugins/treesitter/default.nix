{ pkgs, ... }:

{
  imports = [
    ./textobjects.nix
    ./context.nix
  ];

  # disable tree-sitter to fold the code on startup
  opts.foldenable = true;
  opts.foldlevelstart = 99;

  plugins.treesitter = {
    enable = true;

    highlight.enable = true;
    indent.enable = false;
    folding.enable = true;
  };
}
