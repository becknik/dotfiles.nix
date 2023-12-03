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

    keyd = { # TODO keyd setup for laptop keyboard & update to new 23.11 API
      enable = false;
      /*settings = {
        main = {
          capslock = "timeout(esc, 180, capslock)";
          #shift = oneshot(shift)
          #meta = oneshot(meta)
          #control = oneshot(control)
          #leftalt = oneshot(alt)
          #rightalt = oneshot(altgr)
          #capslock = overload(control, esc)
        };
      };*/
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
  i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          #fcitx5-material-color
        ];
       ignoreUserConfig = true;
        settings = { # How to determine these? Set `ignoreUserConfig` to false, then configure the setup you'd like &
          # then cat the values of `$HOME/.config/fxcit5/*`
          globalOptions = { # /etc/xdg/fcitx5/config
            "Hotkey/TriggerKeys" = {
              "0" = "Control+Super+space"; # modified this one
            };
          };
          inputMethod = { # /etc/xdg/fcitx5/profile
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "eu"; # For EurKEY
              DefaultIM = "mozc";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-eu"; # "
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "mozc";
              Layout = "";
            };
            "GroupOrder" = {
              "0" = "Default";
            };
          };
        };
      };
  };

  # Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1"; # Just to make sure
    OBSIDIAN_USE_WAYLAND = "1"; # "
    QT_QPA_PLATFORM = "wayland;xcb";
    LIBVA_DRIVER_NAME = "intel"; # Should be redundant
    # Fcitx5
    #GTK_IM_MODULE = "fcitx"; # redundant
    #QT_IM_MODULE = "fcitx"; # "
    #XMODIFIERS = "@im=fcitx"; # "

    #SDL_IM_MODULE=fcitx
    #GLFW_IM_MODULE=ibus # for kitty
  };

  programs = {
    firefox.nativeMessagingHosts.gsconnect = true; # Might be redundant, I think
    nm-applet.enable = true;
  };
}
