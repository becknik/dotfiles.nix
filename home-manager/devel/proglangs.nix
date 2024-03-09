{ system, additionalJDKs, config, pkgs, ... }:

{
  home.packages =
    let
      isNotDarwin = (system != "x86_64-darwin");
      dummyPkg = pkgs.hello;
      makeWhenNotDarwin = pkg: (if isNotDarwin then pkg else dummyPkg);
    in
    with pkgs; [
      # TeX Live
      # Source for new 23.11 interface: https://github.com/NixOS/nixpkgs/issues/250243
      /*(unstable.texlive.withPackages (ps: with ps; [
      scheme-full # Need xelatex which is included right here
      ]))*/
      (makeWhenNotDarwin texliveFull)

      # JS / TypeScript
      nodePackages.eslint_d
      nodejs_latest
      typescript

      # Nix
      # https://github.com/nix-community/nixd
      nixd # TODO Figure out how to set up nixd - Seems like this isn't possible at all so far... https://github.com/nix-community/vscode-nix-ide/issues/363
      nil

      ## Linting
      nixpkgs-fmt
      nixpkgs-lint

      # Python
      python3

      # Haskell
      ghc
      #clean.haskellPackages.ghcup
      /* (haskellPackages.ghcup.override {
      Cabal = haskellPackages.Cabal_3_6_3_0;
      versions = (import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify
         name = "nixpkgs-unstable-versions-5.0.5";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "50a7139fbd1acd4a3d4cfa695e694c529dd26f3a";
       }) {}).haskellPackages.versions;
      }) */

      kotlin
      dotty # = scala 3

      ## Linting
      google-java-format

      # Rust
      rustup #cargo rustc
      lldb

      # C++
      (makeWhenNotDarwin clang_17)
      (makeWhenNotDarwin clang-tools_17)
      cmake
    ];

  # JDK Setup
  programs.java = {
    enable = true;
    # Source: https://whichjdk.com/
    package = pkgs.temurin-bin-21;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.jdks" ];
  # Kudos to @TLATER https://discourse.nixos.org/t/nix-language-question-linking-a-list-of-packages-to-home-files/38520
  home.file = (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/jdk-${jdk.version}";
      value = { source = jdk; };
    })
    [ pkgs.temurin-bin-17 ]));
}
