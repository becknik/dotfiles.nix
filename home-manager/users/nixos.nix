{ lib, userName, ... }:

{
  #  TODO find out where to declare the value of this option...
  /*
    options = {
      customOptions.laptopMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Adjust the (dconf) settings for laptop usage";
      };
    };
  */

  imports = [
    ../default.nix

    ../desktop-env # XDG, GTK-X, Systemd & everything in the desktop-env folder
    ../devel
    ../media

    ../packages.nix # Installation of User Packages
    ../secrets # Secrets management with sops-nix
  ];

  config = {
    home.homeDirectory = "/home/${userName}";
    programs.zsh.oh-my-zsh.plugins = lib.mkAfter [ "systemd" ];

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
