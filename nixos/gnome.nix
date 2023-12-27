{ pkgs, lib, ... }:

let
  # Used to overwrite the lib.mkDefault which uses the lower priority of 1000
  mkForce = value: lib.mkOverride 50 value;
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
      gnome-online-accounts.enable = mkForce false;
      evolution-data-server.enable = lib.mkDefault false;
      gnome-online-miners.enable = lib.mkDefault false;
      tracker-miners.enable = mkForce false;
      tracker.enable = mkForce false;

      ### " gnome.core-shell
      gnome-remote-desktop.enable = mkForce false;
      gnome-initial-setup.enable = mkForce false;
    };
  };


  # Additional GNOME Programs
  programs.gnome-terminal.enable = lib.mkDefault true;
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
    kio-extras # Might solve dolphin log spam "serviceType "ThumbCreator" not found"
    # https://forums.opensuse.org/t/dolphin-cant-create-photo-thumbnails-servicetype-thumbcreator-not-found/170259/6
    gwenview
    kate # This pulls in Konsole and I don't know if I can stop it from doing so, but its fine I guess
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
    gnome-calendar # Might be causing gnome crashs on login/screen unlock
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
