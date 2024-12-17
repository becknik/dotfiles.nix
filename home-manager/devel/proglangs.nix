{ isDarwinSystem, lib, config, pkgs, ... }:

{
  # some pl packages are handy for quickly trying something out etc.
  home.packages = with pkgs; (lib.optional (!isDarwinSystem) texliveFull) ++ [
    unstable.amber-lang

    # JS / TypeScript
    unstable.nodejs_latest
    unstable.pnpm
    unstable.eslint_d
    unstable.prettierd

    # Nix
    unstable.nixd
    unstable.nixpkgs-fmt
    nixpkgs-lint

    # Python
    unstable.python3

    unstable.clang_17
    unstable.clang-tools_17
  ];

  # JDK Setup (https://whichjdk.com/)
  programs.java = { enable = true; package = pkgs.unstable.temurin-bin-21; };

  home.sessionPath = [ "${config.home.homeDirectory}/.jdks" ];
  # Kudos to @TLATER https://discourse.nixos.org/t/nix-language-question-linking-a-list-of-packages-to-home-files/38520
  home.file = (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/jdk-${builtins.elemAt (builtins.splitVersion jdk.version) 0}";
      value = { source = jdk; };
    })
    (with pkgs.unstable; [ temurin-bin-17 temurin-bin-21 temurin-bin ])));
}
