{ system, lib, pkgs, ... }:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./programs/neovim.nix # Nixvim neovim configuration
    ./programs/vscodium.nix
  ];

  # git Setup
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      ## Diff syntax highlighting tools
      diff-so-fancy.enable = true; # Like this better than delta
      #difftastic.enable = true; # Side-by-side diff view in terminal, looks odd to me

      ## (User) Config
      userName = "becknik";
      userEmail = "jannikb@posteo.de";
      extraConfig = {
        init.defaultBranch = "main";
        core = {
          filemode = false; # ignores file permission changes
          autocrlf = "input"; # CRLF -> LF; use true for LF -> CRLF -> LF (intersting for Windows)
        };
        push.dafault = "current";
        merge.tool = "vscodium";
        mergetool."vscodium".cmd = "vscodium --wait $MERGED";
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };

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
  home.packages = with pkgs; [
    git-crypt
    meld
    wiggle

    # LLM (ChatGPT)
    shell_gpt

    # JetBrains IDEs
    unstable.jetbrains.clion
    unstable.jetbrains.idea-ultimate

    ## OCI Containers
    dive # https://github.com/wagoodman/dive
    trivy

    ## Build Tools
    gradle
    maven
    gnumake

    ## Testing
    httpie
    newman

    # Latest postman build fails to download - last checked 2023.12.06
    #> curl: (22) The requested URL returned error: 404
    #> error: cannot download postman-10.18.6.tar.gz from any mirror
    (import
      (builtins.fetchGit {
        name = "nixpkgs-unstable-postman-10.15.0";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-unstable";
        rev = "976fa3369d722e76f37c77493d99829540d43845";
      })
      {
        inherit system;
        config.allowUnfree = true;
      }).postman

    ### SQL
    (dbeaver.override { jdk17 = temurin-bin-17; })

    ## CI / CD
    awscli2
    kubectl
    act
  ];
}
