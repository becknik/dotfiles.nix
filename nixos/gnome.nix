{ pkgs, lib, ... }:

{
  # Basic GNOME Desktop Environment Setup
  services = {
    xserver = {
      enable = true;

      ## X11
      layout = "eu";
      xkbVariant = "";

      ## GDM
      displayManager.gdm = {
        enable = true;
        #wayland = true; # redundant
      };
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


  # Additional GNOME Programs
  programs.gnome-terminal.enable = lib.mkDefault true; # TODO add fedora transparency patches
  #programs.gpaste.enable = true;

  ## Manual Installation of additional Tools
  environment.systemPackages = with pkgs.gnome; [
    dconf-editor
    ghex
    gnome-sound-recorder
    gnome-tweaks
    gnome-themes-extra
    pomodoro
    gnome-power-manager
    gnome-software
  ] ++ (with pkgs; [
    tela-icon-theme
    gnome-decoder
    gnome-extension-manager
    networkmanagerapplet # redundant (see desktop-env), but necessary for home-manager to find the .desktop file
  ])


  # KDE/ Qt Support

  ## Manual Installations
  ++ (with pkgs; [
    gedit
    colord-kde
    adwaita-qt
    adwaita-qt6
    # Should be redundant due to the qt.platformTheme setting below...
    qgnomeplatform
    qgnomeplatform-qt6

    #libsForQt5.qtstyleplugin-kvantum
    #qt6Packages.qtstyleplugin-kvantum
  ])


  ## Replacements for GNOME Tools
  ++ (with pkgs.libsForQt5; [
    dolphin
    dolphin-plugins
    kio-extras # Solves spam of "serviceType "ThumbCreator" not found"
    # TODO find a way to enable dav connections and further network protocols in dolphin
    #org.kde.dolphin.desktop[294371]: kf.service.services: KApplicationTrader: mimeType "x-scheme-handler/dav" not found
    #kf.kio.core: couldn't create worker: "Unknown protocol 'dav'
    gwenview
    kate # TODO This pulls in Konsole and I don't know if I can stop it from doing so, but its fine I guess
    #(kate.override { propagatedUserEnvPkgs = []; })
    ktouch
    okular
  ])


  # Adding some GNOME Extensions
  ++ (with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    blur-my-shell
    dash-to-dock
    espresso
    gsconnect
    gtile
    just-perfection
    kimpanel # GTK-ish fcitx5 theming
    logo-menu
    #pixel-saver
    quick-settings-tweaker
    rounded-window-corners
    vitals

    #auto-move-windows # redundant & causes collisions warnings on gnome 45
    #launch-new-instance # redundant & causes collision warnings on gnome 45
    #workspace-indicator-2 # gnome-45 might bring a good default one making this unnecessary

    # Missing: windowsNavigator nasa-pod window-list places-menu gtk4-ding apps-menu (what's this?!)
  ]);

  ## Leftover KDE Support
  qt = {
    enable = true;
    platformTheme = "gnome"; # leverages qgnomeplatform package; redundant due to gnome.core-os-services
    style = "adwaita-dark";
  };


  # Remove Bloat & Tools to be replaced
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


  ## Konsole removal (not working)... :(
  /*environment.libsForQt5.excludePackages = (with pkgs; [
    libsForQt5.konsole
  ]);*/
}
