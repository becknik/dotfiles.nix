{
  pkgs,
  ...
}:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./programs/git.nix
  ];

  programs = {
    # GitHub CLI
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # DirEnv Setup
    direnv = {
      enable = true; # nix-direnv gets enabled automatically in NixOS - but not in home-manager...
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    # SSH
    # Source: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
    ssh = {
      enable = true;

      includes = [ "~/.ssh/config.local" ];

      matchBlocks = {
        "*" = {
          forwardAgent = true;
          hashKnownHosts = true;
          addKeysToAgent = "yes";
        };

        github_personal = {
          host = "github.com";
          user = "git";
          identityFile = "~/.ssh/github-becknik";
        };
        gitlab_personal = {
          host = "gitlab.com";
          user = "git";
          identityFile = "~/.ssh/gitlab-becknik";
        };
      };
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
            clion
            idea-ultimate
            unstable.android-studio
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
      git-crypt
      meld
      wiggle
      watchman # necessary for some npm scripts
      (if !pkgs.stdenv.isDarwin then distrobox else hello)

      # LLM (ChatGPT)
      shell-gpt

      ## Testing
      httpie
      pgadmin4-desktopmode

      ## OCI Containers
      dive # https://github.com/wagoodman/dive
      trivy

      ## CI / CD
      kubectl
      act
    ]
    ++ [ nixvim ];

  home.sessionVariables.EDITOR = "nvim";
}
