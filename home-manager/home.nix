{ stateVersion, ... }:

{
  home = {
    inherit stateVersion;

    # Home Manager needs a bit of information about you and the paths it should manage.
    username = "jnnk";
    homeDirectory = "/home/jnnk";
  };

  # Lets Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./packages.nix # Installation of User Packages
    ./desktop-env.nix # XDG, GTK-X, Systemd & everything in the desktop-env folder

    ./secrets.nix # Secrets management with sops-nix

    ./devel.nix
    ./media.nix
  ];

  # Backups
  programs = {
    borgmatic = {
      # TODO Setup automatic backups for the home-directory
      enable = false;
      backups = { };
    };
  };
}
