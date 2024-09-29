{ isDarwinSystem, pkgs, ... }:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./programs/git.nix
    ./programs/vscodium.nix
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
      extraConfig = "AddKeysToAgent confirm"; #addKeysToAgent = "confirm"; isn't working?
      forwardAgent = true;
      hashKnownHosts = true;
      matchBlocks = {
        github_personal = {
          host = "github.com";
          user = "git";
          identityFile = "~/.ssh/github-personal";
        };
        gitlab_personal = {
          host = "gitlab.com";
          user = "git";
          identityFile = "~/.ssh/github-personal";
        };
        gitlab_sopra = {
          host = "gila24.informatik.uni-stuttgart.de";
          user = "git";
          identityFile = "~/.ssh/gitlab-est";
          addressFamily = "inet";
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
    pinentryPackage = pkgs.pinentry-gnome3;
    #sshKeys = {}; # Expose GPG-keys as SSH-keys
  };
  programs.gpg.enable = true;

  # Manual Installations
  home.packages = with pkgs; let
    jetbrainsTools = (with unstable.jetbrains; lib.lists.optionals (!isDarwinSystem) [ clion idea-ultimate ])
      ++ lib.lists.optional (!isDarwinSystem) jetbrains-toolbox; # use this one for experiments
    # not using unstable.jetbrains-toolbox because it depends on to much & I'm not using it that often
  in
  jetbrainsTools ++ [
    git-crypt
    meld
    wiggle

    # LLM (ChatGPT)
    shell-gpt

    ## Testing
    httpie

    ## OCI Containers
    dive # https://github.com/wagoodman/dive
    trivy

    ## CI / CD
    kubectl
    act
  ]
  # custom standalone variant of nixvim
  ++ [ nixvim ];

  home.sessionVariables.EDITOR = "nvim";
}
