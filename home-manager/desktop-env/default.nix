{
  userName,
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./shell

    ./folders-and-files.nix # Creates my basic folder structure

    ./dconf.nix
    ./xdg-mime.nix # Default apps - I think this might grow rapidly

    ./autostart.nix # Sad try on xdg-autostarting some apps
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
  xdg.configFile."gtk-3.0/settings.ini".force = true; # Only necessary for first deployment (?)

  gtk = {
    enable = true;
    gtk4.extraConfig = {
      gtk-im-module = "ibus";
    };
    gtk3 = {
      bookmarks = [
        "file:///home/${userName}/nextcloud/uni/current-courses"
        "file:///home/${userName}/devel"
        "file:///home/${userName}/nextcloud"
      ];
      extraConfig = {
        gtk-recent-files-limit = 0;
        gtk-application-prefer-dark-theme = 1; # Sets "Legacy Applications" to "Adwaita-dark" theme
        gtk-im-module = "ibus";
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
  dconf.settings."org/gnome/desktop/interface" = {
    # gtk-theme = "Adwaita-dark";
    color-scheme = "prefer-dark";
    icon-theme = lib.mkForce "Tela-dark";
  };
  home.packages = with pkgs; [ tela-icon-theme ];
}
