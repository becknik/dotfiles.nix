{
  isDarwinSystem,
  pkgs,
  ...
}:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./programs/git.nix
    ./programs/vscodium
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

      extraConfig = "AddKeysToAgent confirm"; # addKeysToAgent = "confirm"; isn't working?
      forwardAgent = true;
      hashKnownHosts = true;
      matchBlocks = {
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

  # GPG-Agent
  services.gpg-agent = {
    # TODO use keychain instead of gpg-agent?
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    extraConfig = "";
    pinentry.package = pkgs.pinentry-gnome3;
    #sshKeys = {}; # Expose GPG-keys as SSH-keys
  };
  programs.gpg.enable = true;

  # Manual Installations
  home.packages =
    with pkgs;
    let
      jetbrainsTools =
        lib.lists.optionals (!isDarwinSystem) (
          with unstable.jetbrains;
          [
            clion
            idea-ultimate
            unstable.android-studio
          ]
        )
        ++ lib.lists.optionals (!isDarwinSystem) [ jetbrains-toolbox ]; # used for experiments
      # not using unstable.jetbrains-toolbox because it depends on too much & I'm not using it that often
    in
    jetbrainsTools
    ++ [
      devenv
      git-crypt
      meld
      wiggle
      watchman # necessary for some npm scripts
      distrobox

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
