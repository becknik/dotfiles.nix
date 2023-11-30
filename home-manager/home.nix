{ ... }:

{
  home.stateVersion = "23.11";

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "jnnk";
  home.homeDirectory = "/home/jnnk";

  # Lets Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./packages.nix # Installation of User Packages
    ./desktop-env.nix # XDG, GTK-X, Systemd & everything in the desktop-env folder

    ./virtualisation.nix # Tiny user setup of libvirt

    ./devel.nix
    ./media.nix
  ];

  # Backups
  programs = {
    borgmatic = { # TODO Setup automatic backups for the home-directory
      enable = false;
      backups = {};
    };
  };
}
