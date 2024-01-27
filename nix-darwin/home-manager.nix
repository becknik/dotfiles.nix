{ stateVersion, defaultUser, lib, pkgs, ... }:

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
    homeDirectory = (lib.mkOverride 50 "/Users/${defaultUser}"); # mkOverride is necessary to prevent `/var/empty`
  };

  programs.home-manager.enable = true;

  environment.variables."NIXOS_CONFIGURATION_NAME" = "wnix";

  services.gpg-agent.enable = (lib.mkOverride 50 false);

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
