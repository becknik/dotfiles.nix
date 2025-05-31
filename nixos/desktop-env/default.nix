{ pkgs, lib, ... }:

{
  imports = [
    ./packages.nix # Installation of a few system packages & browsers
    ./gnome.nix # Addition of some kde tools, removal of bloat, etc.
  ];

  xdg.portal = {
    #enable = true; # redundant due to gnome.core-os-services
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ]; # No specific reason to enable this
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
  i18n.inputMethod = {
    type = "ibus";
    enable = true;
    ibus.engines = with pkgs.ibus-engines; [ anthy ]; # mozc
  };

  # Environment variables
  environment.sessionVariables = {

    ## Wayland
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_USE_WAYLAND = "1"; # "
    QT_QPA_PLATFORM = "wayland";
  };

  # Etc
  programs.nm-applet.enable = true;
}
