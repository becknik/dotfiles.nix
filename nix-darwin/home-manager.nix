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
  ];

  home = {
    inherit stateVersion;

    username = defaultUser;
    homeDirectory = (mkForce "/Users/${defaultUser}"); # mkOverride is necessary to prevent `/var/empty`
  };

  programs.home-manager.enable = true;

  # Settings changes from normal home-manager configuration
  services.gpg-agent.enable = (lib.mkOverride 50 false); # incompatible with darwin
  programs.git = {
    userName = (mkForce "Jannik Becker");
    userEmail = (mkForce "sprinteins.becker@extaccount.com");
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
