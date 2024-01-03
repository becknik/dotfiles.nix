{ config, ... }:

{
  imports = [
    ./desktop-env/shell.nix # zsh, oh-my-zsh and bash config

    ./desktop-env/folders-and-files.nix # Creates my basic folder structure

    ./desktop-env/dconf.nix
    ./desktop-env/xdg-mime.nix # Default apps - I think this might grow rapidly
    ./desktop-env/plasma.nix # Setup of KDE apps with plasma-manager, partly by using the plasma-manager auto exporter on Arch

    ./desktop-env/autostart.nix # Sad try on xdg-autostarting some apps
  ];

  # XDG
  xdg = {
    enable = true; # activates XDG user directory management
    #cacheHome = "/tmp/cache-$USER/"; # no great idea due to some important cached data e.g. keypassxc

    ## User Dirs
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/dtop"; # to enable quick jump to devel in VSCode Ctrl + K, O
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dl";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pics";
      publicShare = "${config.home.homeDirectory}/pub-share";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/vids";
    };
  };
  #home.packages = with pkgs; [ handlr-regex ]; # Doesn't work on NixOS :(

  xdg.configFile."gtk-3.0/settings.ini".force = true; # Only necessary for first deployment (?)
  gtk = {
    enable = true;
    gtk3 = {
      bookmarks = [
        "file:///home/jnnk/nextcloud/Uni/current-courses"
        "file:///home/jnnk/devel"
        "file:///home/jnnk/nextcloud"
      ];
      extraConfig = {
        gtk-recent-files-limit = 0;
        gtk-application-prefer-dark-theme = 0; # Sets "Legacy Applications" to "Adwaita-dark" theme
      };
      # Minimizes the gtk-3 header-bar
      extraCss = ''
        headerbar.default-decoration {
          padding-top: 5px;
          padding-bottom: 5px;
          min-height: 0px;
          font-size: 0.8em;
        }
      '';
    };
  };
}
