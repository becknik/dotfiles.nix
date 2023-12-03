{ pkgs, ... }:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./devel/ides.nix # Tiny installation of ides without need for configuration

    #./programs/neovim.nix # Nixvim neovim configuration
    ./programs/vscodium.nix
  ];

  # git Setup
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true; # delta synatx highlighter
      #diff-so-fancy.enable = true; # TODO etra syntax highlighter for diffs
      #difftastic.enable = true; # TODO side-by-side diff view in terminal <3
      userName = "Jannik Becker";
      userEmail = "jannikb@posteo.de";
      extraConfig = {
        init.defaultBranch = "main"; # TODO ist this even necessary?
        core = {
          filemode = false; # ignores file permission changes
          autocrlf = "input"; # CRLF -> LF; use true for LF -> CRLF -> LF (intersting for Windows)
        };
        push.dafault = "current";
        merge.tool = "vscodium";
        mergetool."vscodium".cmd = "vscodium --wait $MERGED";
        url."git@github.com:".insteadOf = "https://github.com/";

        repositories = {
          /*bullet_train = { # TODO this won't work, sadly
            url = "https://github.com/caiogondim/bullet-train.zsh.git";
            path = "${config.programs.zsh.oh-my-zsh.custom}/plugins/";
            interval = 1;
          };*/
        };
      };
    };

    # GitHub CLI
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # DirEnv Setup
    direnv.enable = true; # nix-direnv gets enabled automatically in NixOs - but not in home-manager...
    direnv.nix-direnv.enable = true;

    # SSH
    # Source: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
    ssh = {
      enable = true;
      extraConfig = "AddKeysToAgent confirm";
      forwardAgent = true;
      hashKnownHosts = true;
      #extraOptionOverrides = {};
    };

    # TODO fzf & whats the difference between the `fuzzyCompletion` and `keybindings` attributes NixOS offers?
  };

  ## GPG-agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    extraConfig = "";
    pinentryFlavor = "gnome3";
    #sshKeys = {}; # Expose GPG-keys as SSH-keys
  };

  # Manual Installations
  home.packages = with pkgs; [
    neovim
    git-crypt
    meld

    ## Build Tools
    gradle
    maven

    ## Testing
    httpie
    newman
    #postman # TODO failed to build on update to 23.11

    ### SQL
    dbeaver

    ## CI / CD
    awscli2
    kubectl
    act
  ];

  /*programs.awscli = { TODO this doesn't work so far...
    enable = true;
    settings = {
      "default" = {
        region = "eu-central-1";
      };
    };
    credentials = {}; # TODO
  };*/
}