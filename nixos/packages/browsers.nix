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
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.gnome-search-provider.enabled" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.compactmode.show" = true;

        # Settings I prefer for default
        "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Startpage";
        "browser.ctrlTab.sortByRecentlyUsed" = true;

        # Source: https://librewolf.net/docs/settings/
        "identity.fxaccounts.enabled" = true;
        "general.autoScroll" = true;
        # Letterboxing
        "privacy.resistFingerprinting.letterboxing" = true;
        # This override allows you to control when a cross-origin refer will be sent, allowing it exclusively when the host matches.
        "network.http.referer.XOriginPolicy" = 2;
      };
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
