{ userName, lib, pkgs, ... }:

{
  imports = [
    ../default.nix

    ../packages.nix
    ../desktop-env/shell.nix
    ../desktop-env/folders-and-files.nix # also want the `$HOME/devel/*` folder structure
    # TODO this also includes the manually created plasma config files...

    ../devel.nix
    ../secrets.nix
  ];

  home.homeDirectory = (lib.mkForce "/Users/${userName}"); # mkForce is necessary to prevent `/var/empty`

  # Settings changes from normal home-manager configuration
  services.gpg-agent.enable = (lib.mkForce false); # incompatible with darwin
  programs = {
    zsh =
      # TODO infinite recursion when using `lib.lists.subtractLists`
      /* let
        oh-my-zsh-default-plugins = builtins.getAttr "plugins" config.programs.zsh.oh-my-zsh;
        plugins' = lib.lists.subtractLists [ "podman" "bgnotify" "systemd" ] oh-my-zsh-default-plugins;
      in */
      {
        oh-my-zsh.plugins = /* lib.mkForce */ [ "ssh-agent" "macos" ] /* ++ plugins' */;
        initExtra = "ssh-add --apple-load-keychain"; # load keys from previous sessions
      };
    # `ssh-add --apple-use-keychain ~/.ssh/<key>`
    ssh.extraConfig = "UseKeychain yes";
    librewolf.enable = lib.mkForce false;

    git = {
      userName = (lib.mkForce "Jannik Becker");
      userEmail = (lib.mkForce "sprinteins.becker@extaccount.com");
    };

    java.package = (lib.mkForce pkgs.temurin-bin-17);
  };

  # Packaging Leftovers

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

  ## Add java packages
  home.file = with pkgs; (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/jdk-${jdk.version}";
      value = { source = jdk; };
    })
    [ temurin-bin-21 temurin-bin-11 temurin-bin-8 ]));


  programs.gpg.enable = true;

  home.packages = with pkgs; [
    iterm2

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
