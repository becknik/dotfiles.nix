{ pkgs, lib, ... }:

let
  gnomeAdditionalTools = with pkgs.gnome; [
    dconf-editor
    ghex
    gnome-sound-recorder
    gnome-tweaks
    gnome-themes-extra
    pomodoro
    gnome-power-manager
  ] ++ (with pkgs; [
    gedit
    gnome-decoder
    gnome-extension-manager
    networkmanagerapplet # redundant (see desktop-env), but necessary for home-manager to link the .desktop file
  ]);

  gnomeExtensions = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator # causing crashes
    blur-my-shell
    dash-to-dock
    espresso
    gsconnect
    gtile
    just-perfection
    kimpanel # GTK-ish fcitx5 theming; causing crashes
    logo-menu
    quick-settings-tweaker
    vitals
  ];

  kdeCompat = with pkgs; [
    colord-kde
    qadwaitadecorations
    qadwaitadecorations-qt6
  ];

  ## Replacements for GNOME Tools
  kdeAdditionalTools = (with pkgs.libsForQt5; [
    dolphin
    dolphin-plugins
    kio-extras # Solves spam of "serviceType "ThumbCreator" not found"
    # TODO find a way to enable dav connections and further network protocols in dolphin
    #org.kde.dolphin.desktop[294371]: kf.service.services: KApplicationTrader: mimeType "x-scheme-handler/dav" not found
    #kf.kio.core: couldn't create worker: "Unknown protocol 'dav'
    gwenview
    okular
  ]);
in
{
  # Basic GNOME Desktop Environment Setup
  services = {
    xserver = {
      enable = true;

      ## X11
      layout = "eu";
      xkbVariant = "";

      ## GDM
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };


    ## GNOME Services
    # Source: https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome = {
      ### Redundant stuff
      gnome-keyring.enable = lib.mkDefault true;

      ### Override the implications of gnome.core-os-services
      #evolution-data-server.enable = lib.mkDefault false; # might be the cause for gnome shell crashes
      gnome-online-accounts.enable = lib.mkForce false;
      gnome-online-miners.enable = lib.mkForce false;
      tracker-miners.enable = lib.mkForce false;
      tracker.enable = lib.mkForce false;

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
  environment.systemPackages = gnomeAdditionalTools
    ++ gnomeExtensions
    ++ kdeCompat
    ++ kdeAdditionalTools;


  # Remove Bloat & Tools replaced by KDE ones
  environment.gnome.excludePackages = (with pkgs.gnome; [
    epiphany
    evince
    eog
    geary
    gnome-calendar
    gnome-contacts
    gnome-music
    nautilus
    sushi
    totem
    yelp
  ]) ++ (with pkgs; [
    gnome-console
    gnome-connections
    gnome-tour
    gnome-photos
    evolutionWithPlugins
    orca
    gnome-text-editor
    gnome-user-docs
  ]);

  environment.variables = {
    QT_WAYLAND_DECORATION = "adwaita";
  };
}
