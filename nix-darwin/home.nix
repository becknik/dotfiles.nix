{ stateVersion, defaultUser, lib, pkgs, ... }:

let
  mkForce = value: lib.mkOverride 50 value;
in
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

    username = defaultUser;
    homeDirectory = (mkForce "/Users/${defaultUser}"); # mkOverride is necessary to prevent `/var/empty`
  };

  programs.home-manager.enable = true;

  # Settings changes from normal home-manager configuration
  services.gpg-agent.enable = (lib.mkOverride 50 false); # incompatible with darwin
  programs = {
    git = {
      userName = (mkForce "Jannik Becker");
      userEmail = (mkForce "sprinteins.becker@extaccount.com");
    };
    java.package = (lib.mkDefault pkgs.temurin-bin-17);
    zsh = {
      oh-my-zsh.plugins = [ "ssh-agent" ];
      initExtra = "ssh-add --apple-load-keychain"; # load keys from previous sessions
    };
    # `ssh-add --apple-use-keychain ~/.ssh/<key>`
    ssh.extraConfig = "UseKeychain yes";
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

  programs.gpg.enable = true;

  home.packages = with pkgs; [
    ## Natural language
    hunspell
    hunspellDicts.de_DE

    ## Daily Software
    obsidian

    ## Privacy
    keepassxc
    gpa
  ];
}
