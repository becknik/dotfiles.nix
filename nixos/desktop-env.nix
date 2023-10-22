{ pkgs, ... }:

{
  xdg.portal = {
    #enable = true; # redundant due to gnome.core-os-services
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ]; # TODO is this even necessary?
    # ++ [ xdg-desktop-portal-gtk ] conflicts with xdg-desktop-portal-gtk of same version already being present on the system
  };

  # Desktop Service Configuration
  services = {
    fwupd.enable = true;
    dbus = {
      packages = [ pkgs.gnome.seahorse ];
    };

    keyd = { # TODO keyd setup for laptop keyboard
      enable = false;
      settings = {
        main = {
          capslock = "timeout(esc, 180, capslock)";
          #shift = oneshot(shift)
          #meta = oneshot(meta)
          #control = oneshot(control)
          #leftalt = oneshot(alt)
          #rightalt = oneshot(altgr)
          #capslock = overload(control, esc)
        };
      };
    };

    psd.enable = true;

    ## CUPS & Printing
    printing = {
      enable = true;
      drivers = with pkgs; [ brgenml1lpr ]; # TODO
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };

    ## PipeWire (1/2)
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  ## PipeWire (2/2)
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true; # TODO What's that?

  # Input
  #i18n.inputMethod.enabled = "fcitx5"; # TODO fcitx5 setup
  #i18n.inputMethod.addons = [ fcitx5-rime ];

  # Old settings from Arch
  #QT_QPA_PLATFORMTHEME='DEFAULT=qt5ct'
  #GLFW_IM_MODULE = DEFAULT=fcitx
  #GTK_IM_MODULE = DEFAULT=fcitx
  #INPUT_METHOD = DEFAULT=fcitx
  #XMODIFIERS  = DEFAULT=@im=fcitx
  #IMSETTINGS_MODULE = DEFAULT=fcitx
  #QT_IM_MODULE = DEFAULT=fcitx

  # Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1"; # Just to make sure
    OBSIDIAN_USE_WAYLAND = "1"; # "
    QT_QPA_PLATFORM = "wayland;xcb";
    LIBVA_DRIVER_NAME = "intel"; # Should be redundant
  };

  programs = {
    firefox.nativeMessagingHosts.gsconnect = true; # Might be redundant, I think
    nm-applet.enable = true;
  };
}
