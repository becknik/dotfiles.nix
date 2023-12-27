{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    enableGnomeExtensions = true;
    package = (pkgs.clean.librewolf.override {
      nativeMessagingHosts = [ pkgs.gnome-browser-connector ]; # TODO nativeMessagingHost wont' work :'(
    });

    settings = {
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
}
