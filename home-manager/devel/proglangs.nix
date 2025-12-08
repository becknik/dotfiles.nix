{
  lib,
  config,
  pkgs,
  ...
}:

{
  # some pl packages are handy for quickly trying something out etc.
  home.packages =
    with pkgs;
    (lib.lists.optionals (!pkgs.stdenv.isDarwin) [
      tectonic
      typst
      conda
    ])

    ++ [
      unstable.amber-lang

      # JS / TypeScript
      unstable.nodejs_latest
      unstable.pnpm

      # Python
      python3

      unstable.clang
      unstable.clang-tools
    ];

  # JDK Setup (https://whichjdk.com/)
  programs.java = {
    enable = true;
    package = pkgs.unstable.temurin-bin-21;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.jdks" ];
  # Kudos to @TLATER https://discourse.nixos.org/t/nix-language-question-linking-a-list-of-packages-to-home-files/38520
  home.file = (
    builtins.listToAttrs (
      builtins.map
        (jdk: {
          name = ".jdks/jdk-${builtins.elemAt (builtins.splitVersion jdk.version) 0}";
          value = {
            source = jdk;
          };
        })
        (
          with pkgs;
          [
            temurin-bin-17
            temurin-bin-21
            unstable.temurin-bin
          ]
        )
    )
  );
}
