{ stateVersion, userName, lib, pkgs, ... }:

{
  imports = [
    ../home-manager/packages.nix
    ../home-manager/desktop-env/shell.nix
    ../home-manager/desktop-env/folders-and-files.nix # also want the `$HOME/devel/*` structure

    ../home-manager/devel.nix
    ../home-manager/secrets.nix
  ];

  home = {
    inherit stateVersion;

    username = userName;
    homeDirectory = (lib.mkForce "/Users/${userName}"); # mkForce is necessary to prevent `/var/empty`
  };

  programs.home-manager.enable = true;

  # Settings changes from normal home-manager configuration
  services.gpg-agent.enable = (lib.mkForce false); # incompatible with darwin
  programs = {
    git = {
      userName = (lib.mkForce "Jannik Becker");
      userEmail = (lib.mkForce "sprinteins.becker@extaccount.com");
    };
    java.package = (lib.mkForce pkgs.temurin-bin-17);
    zsh = {
      oh-my-zsh.plugins = [ "ssh-agent" "macos" ];
      initExtra = "ssh-add --apple-load-keychain"; # load keys from previous sessions
    };
    # `ssh-add --apple-use-keychain ~/.ssh/<key>`
    ssh.extraConfig = "UseKeychain yes";
    librewolf.enable = lib.mkForce false;
  };

  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    settings = {
      scrollback_lines = 25000;
      enable_audio_bell = true;
      update_check_interval = 0;
    };
    theme = "Desert";
  };

  # Packaging Leftovers

  ## Add java packages
  home.file = with pkgs; (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/jdk-${jdk.version}";
      value = { source = jdk; };
    })
    [ temurin-bin-21 temurin-bin-11 temurin-bin-8 ]));


  programs.gpg.enable = true;

  home.packages = with pkgs; [
    # media.nix leftovers
    ## Natural language
    hunspell
    hunspellDicts.de_DE

    ## Daily Software
    obsidian

    ## Privacy
    keepassxc
    gpa

    # build tools
    kubernetes-helm
  ];
}