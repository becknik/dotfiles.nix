{ lib, stateVersion, defaultUser, ... }:

{
  /*options = { TODO find out where to declare the value of this option...
    customOptions.laptopMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Adjust the (dconf) settings for laptop usage";
    };
  };*/

  imports = [
    ./packages.nix # Installation of User Packages
    ./desktop-env.nix # XDG, GTK-X, Systemd & everything in the desktop-env folder

    ./secrets.nix # Secrets management with sops-nix

    ./devel.nix
    ./media.nix
  ];

  config = {
    home = {
      inherit stateVersion;

      # Home Manager needs a bit of information about you and the paths it should manage.
      username = defaultUser;
      homeDirectory = "/home/${defaultUser}";
    };

    # Lets Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Backups
    programs = {
      borgmatic = {
        # TODO Setup automatic backups for the home-directory
        enable = false;
        backups = { };
      };
    };
  };
}
