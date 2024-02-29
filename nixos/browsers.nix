{ lib, pkgs, ... }:

{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.librewolf-wayland;
      languagePacks = [ "en-US" "de" "ja" ];
      nativeMessagingHosts = {
        packages = with pkgs; [ gnomeExtensions.gsconnect keepassxc ];
        gsconnect = lib.mkOverride 50 false; # deprecated option
      };
      #preferences = { }; # Defined via home-manager, due to not getting applied from here
    };


    # Chromium (configuration policies only)
    chromium = {
      enable = true;
      #defaultSearchProviderEnabled = true; # doesn't work...
      homepageLocation = "https://chat.openai.com/?model=gpt-4";
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
}
