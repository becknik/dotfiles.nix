{ isDarwinSystem, pkgs, ... }:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./programs/git.nix
    ./programs/nixvim.nix # Nixvim neovim configuration
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
    pinentryFlavor = "gnome3";
    #sshKeys = {}; # Expose GPG-keys as SSH-keys
  };
  programs. gpg. enable = true;

  # Manual Installations
  home.packages = with pkgs; let
    jetbrainsTools = with unstable.jetbrains; [ clion idea-ultimate ]
      ++ lib.lists.optional (!isDarwinSystem) unstable.jetbrains-toolbox; # use this one for experiments
  in
  jetbrainsTools ++ [
    git-crypt
    meld
    wiggle

    # LLM (ChatGPT)
    shell_gpt

    ## Build Tools
    gradle
    maven
    gnumake

    ## Testing
    newman
    unstable.postman
    httpie
    jq

    ## OCI Containers
    dive # https://github.com/wagoodman/dive
    trivy

    ## CI / CD
    #awscli2
    kubectl
    act
  ];
}
