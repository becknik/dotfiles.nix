{
  pkgs,
  lib,
  isLaptop,
  ...
}:

let
  gnomeAdditionalTools =
    with pkgs;
    [
      dconf-editor
      ghex
      gnome-sound-recorder
      gnome-tweaks
      gnome-themes-extra
      gnome-pomodoro
      gnome-decoder
      networkmanagerapplet # redundant (see desktop-env), but necessary for home-manager to link the .desktop file
      baobab
      gnome-calculator
      gnome-font-viewer
      gnome-weather
      simple-scan
      snapshot
      nautilus # necessary for file selection dialog
    ]
    ++ lib.lists.optionals isLaptop (with pkgs; [ gnome-power-manager ]);

  gnomeExtensions = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator # causing crashes
    blur-my-shell
    dash-to-dock
    caffeine
    gsconnect
    gtile
    just-perfection
    kimpanel # GTK-ish kimpanel theming for fxcit/ ibus; causing crashes
    logo-menu
    quick-settings-tweaker
    vitals
  ];

  kdeCompat = with pkgs; [
    kdePackages.colord-kde
    qadwaitadecorations
    qadwaitadecorations-qt6
  ];

  ## Replacements for GNOME Tools
  kdeAdditionalTools = with pkgs.kdePackages; [
    dolphin
    dolphin-plugins
    kio-extras # Solves spam of "serviceType "ThumbCreator" not found"
    # TODO find a way to enable dav connections and further network protocols in dolphin
    #org.kde.dolphin.desktop[294371]: kf.service.services: KApplicationTrader: mimeType "x-scheme-handler/dav" not found
    #kf.kio.core: couldn't create worker: "Unknown protocol 'dav'
    gwenview
    okular
    ark # archive manager
  ];
in
{
  # Basic GNOME Desktop Environment Setup
  services = {
    xserver = {
      enable = true;

      ## X11
      xkb.layout = "eu";

      ## GDM
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        sessionPath = [ pkgs.gnome-shell-extensions ];
      };
    };

    ## GNOME Services
    # Source: https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome = {
      # core-apps.enable = false;
      games.enable = false;
      ### Redundant stuff
      gnome-keyring.enable = lib.mkDefault true;

      ### Override the implications of gnome.core-os-services
      #evolution-data-server.enable = lib.mkDefault false; # might be the cause for gnome shell crashes
      gnome-online-accounts.enable = lib.mkForce false;
      localsearch.enable = lib.mkForce false;
      # tinysparql.enable = lib.mkForce false;
      # evolution-data-server.enable = lib.mkForce false;

      ### " gnome.core-shell
      gnome-remote-desktop.enable = lib.mkForce false;
      gnome-initial-setup.enable = lib.mkForce false;
    };
  };

  # Leftover KDE Support
  qt = {
    enable = true;
    style = "breeze";
  };

  # Additional GNOME Programs
  programs.gnome-terminal.enable = false;
  #programs.gpaste.enable = true;
  environment.systemPackages =
    gnomeAdditionalTools ++ gnomeExtensions ++ kdeCompat ++ kdeAdditionalTools;

  # Remove Bloat & Tools replaced by KDE ones
  environment.gnome.excludePackages = with pkgs; [
    evince
    eog
    geary
    sushi
    gnome-tour
    gnome-photos
    orca
    gnome-user-docs

    decibels
    epiphany
    file-roller
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-disk-utility
    gnome-logs
    gnome-maps
    gnome-music
    gnome-software
    gnome-system-monitor
    gnome-text-editor
    libportal
    libportal-gtk3
    libshumate
    loupe
    totem
    yelp
    yelp-xsl
    # folks gnome-calendar gnome-mimeapps grilo grilo-plugins libdmapsharing gtk-frdp liboauth libspelling
  ];

  environment.variables = {
    QT_WAYLAND_DECORATION = "adwaita";
  };
}
