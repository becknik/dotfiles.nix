{ stateVersion, userName, ... }:

{
  #  TODO find out where to declare the value of this option...
  /*options = {
    customOptions.laptopMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Adjust the (dconf) settings for laptop usage";
    };
  };*/

  imports = [
    ../default.nix

    ../packages.nix # Installation of User Packages
    ../desktop-env.nix # XDG, GTK-X, Systemd & everything in the desktop-env folder

    ../secrets.nix # Secrets management with sops-nix

    ../devel.nix
    ../media.nix
  ];

  config = {
    home.homeDirectory = "/home/${userName}";

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

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
