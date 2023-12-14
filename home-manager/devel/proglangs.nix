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

    ## Linting
    nixpkgs-fmt
    nixpkgs-lint

    # Rust
    cargo
    rustc
    lldb

    # C++
    unstable.gcc
    (unstable.clang.overrideAttrs (oldAttrs: {
      meta.priority = -10;
    }))
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
