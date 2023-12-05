{ config, lib, pkgs, ...}:
{
  programs = {
    git.enable = true;

    # System Neovim Setup
    # Gets overwritten by the home-manager one
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # Chromium (in the hope that the home-managed version reads this)
    chromium = {
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
  };

  # Manual Installation
  environment.systemPackages = with pkgs; [
    linux-firmware

    ## Utils
    efibootmgr
    usbutils
    cryptsetup
  ];

  # "Bloat" Removal
  services.xserver.excludePackages = with pkgs; [ xterm ]; # I hate multiple terminals on the system...

  # Fonts
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    packages = with pkgs; [
      ipaexfont
      monoid
      joypixels
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" "SourceCodePro" ]; })
    ];
  };

  # Prints all system packages (installed by configuration.nix) into /etc/current-system-packages.txt
  environment.etc."current-system-packages.txt".text =
    let
      packages = builtins.map (p: "${ p.name }") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;
}
