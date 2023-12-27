{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # JS / TypeScript
    nodePackages.eslint_d
    nodejs_latest
    typescript

    # Nix
    # https://github.com/nix-community/nixd
    unstable.nixd # TODO Figure out how to set up nixd - Seems like this isn't possible at all so far... https://github.com/nix-community/vscode-nix-ide/issues/363
    unstable.nil

    ## Linting
    nixpkgs-fmt
    nixpkgs-lint

    # Python
    python3

    # Haskell
    ghc
    #clean.haskellPackages.ghcup
/*     (haskellPackages.ghcup.override {
      Cabal = haskellPackages.Cabal_3_6_3_0;
      versions = (import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify
         name = "nixpkgs-unstable-versions-5.0.5";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "50a7139fbd1acd4a3d4cfa695e694c529dd26f3a";
     }) {}).haskellPackages.versions;
    }) */

    # JVM
    # TODO Install multiple JDK version system wide
    /*(pkgs.temurin-bin-17.overrideAttrs (oldAttrs: {
      meta.priorty = 10;
    }))*/
    /*(temurin-bin-11.overrideAttrs (oldAttrs: {
      meta.priorty = 10;
    }))*/

    kotlin
    dotty # = scala 3

    ## Linting
    google-java-format

    # Rust
    cargo
    rustc
    lldb

    # C++
    gcc_latest
    (clang_17.overrideAttrs (oldAttrs: {
      meta.priority = -10;
    }))
    clang-tools_17
    cmake
  ];

  # JDK Setup
  programs.java = {
    enable = true;
    # Source: https://whichjdk.com/
    package = pkgs.temurin-bin-21.overrideAttrs (oldAttrs: {
      meta.priorty = -10;
    });
  };
}
