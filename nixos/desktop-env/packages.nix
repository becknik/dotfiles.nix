{ config, lib, pkgs, ... }:

{
  # Chromium (configuration policies only)
  programs.chromium = {
    enable = true;
    #defaultSearchProviderEnabled = true; # doesn't work...
    # homepageLocation = "https://chat.openai.com/?model=gpt-4"; # " - "
    extraOpts = {
      "SavingBrowserHistoryDisabled" = true;
      "AllowDeletingBeowserHistory" = true;
      # Source: https://discourse.nixos.org/t/how-to-configure-chromium/7334/2
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      #"PasswordManagerEnabled" = false;
      "BuiltInDnsClientEnabled" = false;
      "MetricsReportingEnabled" = true;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [ "de" "en-US" ];
      "CloudPrintSubmitEnabled" = false;
    };
  };

  environment.variables.EDITOR = "nvim";

  # Manual Installation
  environment.systemPackages = with pkgs; [
    libnotify # For the noixos-upgrade systemd notifier units
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
