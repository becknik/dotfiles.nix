{ config, lib, pkgs, ...}:
{
  imports = [ ./packages/linux-xanmod.nix ];

  # System-level packages
  programs = {
    git.enable = true;

    ## TODO System Neovim Setup
    /*neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };*/

    ## Chromium (in the hope that the home-managed version reads this)
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

  ## TODO PGAdmin?
  /*deployment.keys."pgadmin-local" = {
    text = "admin";
    user = config.users.users.pgadmin.name;
    group = config.users.users.pgadmin.group;
    persmissions = "0400";
  };*/

  /*services= {
    pgadmin = {
      enable = true;
      initialEmail = "jannikb@posteo.de";
      initialPasswordFile = /run/keys/pgadmin-local; # TODO
      settings = {
        SERVER_MODE = lib.mkDefault false;
      };
      openFirewall = false; # just to make sure
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql;
      authentication = lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
  };*/

  ## Manual installation
  environment.systemPackages = with pkgs; [
    linux-firmware

    ### Utils
    efibootmgr
    usbutils
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
    /*enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Vazirmatn" "Ubuntu" ];
        sansSerif = [ "Vazirmatn" "Ubuntu" ];
        monospace = [ "Ubuntu" ];
      };
    };*/
  };

  # Print all via configuration.nix installed packages into /etc/current-system-packages.txt
  environment.etc."current-system-packages.txt".text =
    let
      packages = builtins.map (p: "${ p.name }") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;
}
