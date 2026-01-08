{ pkgs, ... }:

{
  catppuccin.firefox.profiles = { };
  catppuccin.librewolf.profiles = { };

  home.file = {
    "gsconnect-librewolf-message-hosts" = {
      target = ".librewolf/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
      source = "${pkgs.gnomeExtensions.gsconnect}/lib/mozilla/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
    };
  };

  programs = {
    zen-browser = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        gnomeExtensions.gsconnect
        gnome-browser-connector
        keepassxc
      ];
      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        Preferences =
          let
            locked = value: {
              "Value" = value;
              "Status" = "locked";
            };
          in
          {
            "browser.tabs.warnOnClose" = locked false;

            "browser.ctrlTab.sortByRecentlyUsed" = locked true;
            "browser.engagement.ctrlTab.has-used" = locked true;

            "browser.tabs.loadInBackground" = locked true;
            "doh-rollout.disable-heuristics" = locked true;
            "dom.security.https_only_mode" = locked true;
            "dom.security.https_only_mode_ever_enabled" = locked true;

            "general.autoScroll" = locked true;
            "general.smoothScroll" = locked true;
            "intl.accept_languages" = locked "en-us,de,en";
            "intl.locale.requested" = locked "en-US,de,en-GB";
            "layout.css.prefers-color-scheme.content-override" = locked 0;

            "network.trr.mode" = locked 3;
            "network.trr.uri" = locked "https://mozilla.cloudflare-dns.com/dns-query";

            "pref.browser.language.disable_button.up" = locked false;
            "privacy.clearOnShutdown_v2.formdata" = locked true;
            "privacy.clearOnShutdown_v2.cache" = locked false;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = locked false;

            "privacy.sanitize.sanitizeOnShutdown" = locked true;
            "privacy.sanitize.pending" =
              locked "[{\"id\":\"shutdown\",\"itemsToClear\":[\"browsingHistoryAndDownloads\"],\"options\":{}}]";

            "zen.workspaces.continue-where-left-off" = locked false;
            "zen.view.compact.should-enable-at-startup" = locked false;
            "zen.view.use-single-toolbar" = locked false;
            "zen.view.window.scheme" = locked 0;
          };
      };
    };

    librewolf = {
      enable = true;
      package = pkgs.unstable.librewolf.override {
        # https://github.com/NixOS/nixpkgs/issues/374882
        # https://github.com/NixOS/nixpkgs/issues/414205
        nativeMessagingHosts = with pkgs; [
          gnomeExtensions.gsconnect
          gnome-browser-connector
          keepassxc
        ];
        # hasMozSystemDirPatch = true;
      };

      settings = {
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.gnome-search-provider.enabled" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.compactmode.show" = true;

        ## Own Preferences
        "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Startpage"; # Doesn't work
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "general.autoScroll" = true;
        "browser.translations.automaticallyPopup" = false;
        "browser.download.useDownloadDir" = true; # Don't ask where to save files

        ## Mozilla Accounts
        "identity.fxaccounts.enabled" = true;

        ## Privacy
        "webgl.disabled" = true;
        "privacy.resistFingerprinting.letterboxing" = true;
        # This override allows you to control when a cross-origin refer will be sent, allowing it exclusively when the host matches.
        "network.http.referer.XOriginPolicy" = 2;
        "signon.firefoxRelay.feature" = "disabled";
        "places.history.enabled" = false;
        ### DNS over TLS
        "network.trr.mode" = 2;
      };
    };
  };
}
