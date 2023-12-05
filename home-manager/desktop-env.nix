{ config, ... }:

{
  imports = [
    ./desktop-env/zsh.nix # zsh and oh-my-zsh config

    ./desktop-env/folders-and-files.nix # Creates my basic folder structure
    ./desktop-env/secrets.nix # Secrets management with sops-nix

    ./desktop-env/dconf.nix
    ./desktop-env/xdg-mime.nix # Default apps - I think this might grow rapidly
    ./desktop-env/plasma.nix # Setup of KDE apps with plasma-manager, partly by using the plasma-manager auto exporter on Arch

    ./desktop-env/autostart.nix # Sad try on xdg-autostarting some apps
  ];

  # Env
  home.sessionVariables = {
    EDITOR = "nvim";
    # Use gpg-agent instead of ssh-agent, which seems to be set before sourcing .zenv? Why? TODO
    # Former seems to be started automatically on every boot, so this value makes sure gpg-agent is used...
    SSH_AUTH_SOCK = ''"''${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"'';
  };

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
      extraCss = # Minimizes the gtk-3 header-bar
''headerbar.default-decoration {
  padding-top: 5px;
  padding-bottom: 5px;
  min-height: 0px;
  font-size: 0.8em;
}'';
    };
    /*gtk4 = {
      extraConfig = {};
      extraCss = {};
    };*/
  };
}

# TODO Cache-persist script?
#[Unit]
#Description=Copy persisting cache files back to ~/.cache
#
#[Service]
#Type=oneshot
#ExecStart=/home/jnnk/scripts/cache-persist.sh start
#ExecStop=/home/jnnk/scripts/persist-cache.sh stop
#RemainAfterExit=yes
#
#[Install]
#WantedBy=default.target
