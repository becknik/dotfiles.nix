{
  config,
  lib,
  pkgs,
  ...
}:

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
      "SpellcheckLanguage" = [
        "de"
        "en-US"
      ];
      "CloudPrintSubmitEnabled" = false;
    };
  };

  # Remove Bloat
  services.xserver.excludePackages = with pkgs; [ xterm ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      ipaexfont
      joypixels
      nerd-fonts.fira-code
      nerd-fonts.sauce-code-pro
      fira-code # paTchINg DesTRoYs fONtS
    ];
    fontconfig = {
      subpixel.rgba = "rgb";
      defaultFonts = {
        serif = [
          "DejaVu Serif"
          "IPAexGothic"
        ]; # this is used as fallback for apps like gedit
        sansSerif = [
          "DejaVu Sans"
          "IPAexGothic"
        ];
        monospace = [
          "FiraCode Nerd Font" # "Source Code Pro"
          "IPAexGothic"
        ];
        emoji = [ "JoyPixels" ];
      };
    };
  };
}
