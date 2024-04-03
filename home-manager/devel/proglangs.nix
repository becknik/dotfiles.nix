{ isDarwinSystem, lib, config, pkgs, ... }:

{
  home.packages =
    let
      clangPackages = with pkgs; lib.optionals (!isDarwinSystem) [ clang_17 clang-tools_17 ];
      texlive = with pkgs; lib.optional (!isDarwinSystem) texliveFull;
    in
    with pkgs; texlive ++ [

      # JS / TypeScript
      typescript
      nodePackages.eslint_d
      nodejs_latest
      deno

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
      unstable.ghc
      unstable.haskell-language-server
      unstable.cabal-install


      # Java / JVM
      kotlin
      dotty # = scala3

      ## Linting
      google-java-format

      # Rust
      rustup #cargo rustc
      lldb

      # C++
      cmake
    ] ++ clangPackages;

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
