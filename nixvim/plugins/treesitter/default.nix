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
    indent.enable = true;
    folding.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/478561
  extraFiles = {
    "queries/ecma/highlights.scm".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries/ecma/highlights.scm";
      sha256 = "sha256-N4NFR+uqnBYMrYfqvTg4fUcisbQNRLq1TY5x0f7/m54=";
    };
    "queries/ecma/indents.scm".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries/ecma/indents.scm";
      sha256 = "sha256-2gI78K/1/YG9+vt1Pz2jBBt8a6lT7wg4IaF6Yir20VU=";
    };
    "queries/ecma/injections.scm".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries/ecma/injections.scm";
      sha256 = "sha256-Dv/twrsEPTSic4RVOPmqae1f6BdkUS5WuS4aX2tbelw=";
    };
    "queries/ecma/folds.scm".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries/ecma/folds.scm";
      sha256 = "sha256-qXsY5St7yLcAde0aeNrRLnLl5a52m7IS2Cdhhqly3ZE=";
    };
    "queries/ecma/locals.scm".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries/ecma/locals.scm";
      sha256 = "sha256-ymzW5O4X3/T/w2B4D88uBKaNKDboesbkYDYgHh89ihU=";
    };
  };
}
