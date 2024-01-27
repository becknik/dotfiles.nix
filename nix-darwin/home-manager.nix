{ stateVersion, defaultUser, lib, pkgs, ... }:

{
  imports = [
    ../home-manager/packages.nix
    ../home-manager/desktop-env/shell.nix
    ../home-manager/desktop-env/folders-and-files.nix # also want the `$HOME/devel/*` structure

    ../home-manager/devel.nix
  ];

  # Fixup of programs not available for darwin
  services.gpg-agent.enable = (lib.mkOverride 50 false);

  home = {
    inherit stateVersion;

    username = defaultUser;
    homeDirectory = (lib.mkDefault "/Users/${defaultUser}");
  };

  programs.home-manager.enable = true;

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
    logseq

    ## Privacy
    keepassxc
    gpa
  ];
}
