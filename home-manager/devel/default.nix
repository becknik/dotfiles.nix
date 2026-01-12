{
  pkgs,
  ...
}:

{
  imports = [
    ./proglangs.nix # Installation of some programming languages

    ./git.nix
    ./ssh.nix
  ];

  programs = {
    # DirEnv Setup
    direnv = {
      enable = true; # nix-direnv gets enabled automatically in NixOS - but not in home-manager...
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };

  # Manual Installations
  home.packages =
    with pkgs;
    let
      jetbrainsTools =
        lib.lists.optionals (!pkgs.stdenv.isDarwin) (
          with unstable.jetbrains;
          [
            idea
          ]
        )
        # not using unstable.jetbrains-toolbox because it depends on too much & I'm not using it that often
        ++ lib.lists.optionals (!pkgs.stdenv.isDarwin) [ jetbrains-toolbox ] # used for experiments
        ++ lib.lists.optionals (!pkgs.stdenv.isDarwin) [ android-tools ];
    in
    jetbrainsTools
    ++ [
      unstable.vscode-fhs

      devenv
      meld
      wiggle
      watchman # necessary for some npm scripts
      (if !pkgs.stdenv.isDarwin then distrobox else hello)

      ## Testing
      httpie
      pgadmin4-desktopmode

      ## OCI Containers
      dive # https://github.com/wagoodman/dive
      trivy
    ]
    ++ [ nixvim ];

  home.sessionVariables.EDITOR = "nvim";
}
