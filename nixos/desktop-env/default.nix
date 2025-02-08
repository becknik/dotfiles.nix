{ pkgs, lib, ... }:

{
  imports = [
    ./packages.nix # Installation of a few system packages & browsers
    ./gnome.nix # Addition of some kde tools, removal of bloat, etc.
  ];

  xdg.portal = {
    #enable = true; # redundant due to gnome.core-os-services
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ]; # No specific reason to enable this
    # ++ [ xdg-desktop-portal-gtk ] conflicts with xdg-desktop-portal-gtk of same version already being present on the system
  };

  # Desktop Service Configuration
  services = {
    fwupd.enable = true;
    dbus = {
      packages = [ pkgs.seahorse ];
    };

    psd.enable = true;

    ## CUPS & Printing
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    ## PipeWire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      audio.enable = true;
      pulse.enable = true;

      # Source: https://wiki.archlinux.org/title/PipeWire/Examples#Echo_cancellation
      # this sadly is unusable in my setup condition...
      extraConfig = {
        client."10-resample-quality"."stream.properties"."resample.quality" = 14;
        pipewire."10-resample-quality"."stream.properties"."resample.quality" = 14;
        pipewire-pulse."10-resample-quality"."stream.properties"."resample.quality" = 14;
      };
    };

    postgresql = {
      enable = true;
      enableTCPIP = true;
      ensureDatabases = [ "mydatabase" ];
      authentication = lib.mkOverride 10 ''
        local all  all  trust
        # ipv4
        host  all  all  127.0.0.1/32   trust
        # ipv6
        host  all  all  ::1/128        trust
      '';
    };
  };
  security.rtkit.enable = true; # Pipewire and Pulse seem to acquire realtime scheduling with this one
  # Declared in pulseaudio.nix and optionally in pipewire.nix

  environment.wordlist.enable = true;

  # Input

  ## Fcitx5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        #fcitx5-material-color
      ];
      ignoreUserConfig = true;
      settings = {
        # How to determine these? Set `ignoreUserConfig` to false, then configure the setup you'd like & then cat the values of `$HOME/.config/fxcit5/*`
        globalOptions = {
          # /etc/xdg/fcitx5/config
          "Hotkey/TriggerKeys" = {
            "0" = "Control+Super+space"; # modified this one
          };
          Behavior = {
            DefaultPageSize = 7;
            OverrideXkbOption = true;
          };
        };
        inputMethod = {
          # /etc/xdg/fcitx5/profile
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

  # Environment variables
  environment.sessionVariables = {

    ## Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1"; # Just to make sure
    OBSIDIAN_USE_WAYLAND = "1"; # "
    QT_QPA_PLATFORM = "wayland";
  };

  # Etc
  programs.nm-applet.enable = true;
}
