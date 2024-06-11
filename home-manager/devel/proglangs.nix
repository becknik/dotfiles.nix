{ isDarwinSystem, lib, config, pkgs, ... }:

{
  # some pl packages are handy for quickly trying something out etc.
  home.packages =
    let
      clangPackages = with pkgs; lib.optionals (!isDarwinSystem) [ clang_17 clang-tools_17 ];
      texlive = with pkgs; lib.optional (!isDarwinSystem) texliveFull;
    in
    with pkgs; texlive ++ [
      # JS / TypeScript
      nodejs_latest

      # Nix
      unstable.nixd
      unstable.nixpkgs-fmt
      nixpkgs-lint

      # Python
      unstable.python3

      unstable.amber-lang
    ];

  # JDK Setup (https://whichjdk.com/)
  programs.java = { enable = true; package = pkgs.unstable.temurin-bin-21; };

  home.sessionPath = [ "${config.home.homeDirectory}/.jdks" ];
  # Kudos to @TLATER https://discourse.nixos.org/t/nix-language-question-linking-a-list-of-packages-to-home-files/38520
  home.file = (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/jdk-${jdk.version}";
      value = { source = jdk; };
    })
    (with pkgs.unstable; [ temurin-bin-17 temurin-bin-21 ])));
}
