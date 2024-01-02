{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    # Enable neovim for root account, besides of nixvim for home-manager user
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Manual Installation
  environment.systemPackages = with pkgs; [
    linux-firmware
    libnotify # For the noixos-upgrade systemd Unit override - Should be included implicitly

    ## Utils
    efibootmgr
    usbutils
    cryptsetup
  ];

  # "Bloat" Removal
  services.xserver.excludePackages = with pkgs; [ xterm ]; # I hate multiple terminals on the system...

  # Fonts
  fonts = {
    packages = with pkgs; [
      ipaexfont
      monoid
      joypixels
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" "SourceCodePro" ]; })
    ];
    fontconfig = {
      subpixel.rgba = "rgb";
      defaultFonts = {
        serif = [ "DejaVu Serif" "IPAexGothic" ];
        sansSerif = [ "DejaVu Sans" "IPAexMincho" ];
        monospace = [ "FiraCode Nerd Font" /* "Source Code Pro" */ ];
        emoji = [ "JoyPixels" ];
      };
    };
  };

  # Prints all system packages (installed by configuration.nix) into /etc/current-system-packages.txt
  environment.etc."current-system-packages.txt".text =
    let
      packages = builtins.map (p: "${ p.name }") config.environment.systemPackages;
      sorted-unique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sorted-unique;
    in
    formatted;
}
