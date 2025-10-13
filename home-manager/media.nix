{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./media/gpg.nix

    ./media/mail.nix
    ./programs/thunderbird.nix
  ];

  # Multimedia
  programs.mpv.enable = true;

  services = {
    # Sync
    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
    /*
      dropbox = { # TODO Dropbox module not working & corresponding home-manager issue is on stall: https://github.com/nix-community/home-manager/issues/4226
        enable = true;
        path = "${config.home.homeDirectory}/dropbox";
      };
    */
  };

  # Browsers

  home.file = {
    "gsconnect-librewolf-message-hosts" = {
      target = ".librewolf/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
      source = "${pkgs.gnomeExtensions.gsconnect}/lib/mozilla/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
    };
  };

  catppuccin.firefox.profiles = { };
  catppuccin.librewolf.profiles = { };

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

            "zen.workspaces.continue-where-left-off" = locked true;
            "zen.view.compact.should-enable-at-startup" = locked true;
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

    chromium = {
      enable = true;
      package = pkgs.unstable.ungoogled-chromium;
      # works for chromium now, but doesn't for electron: https://github.com/electron/electron/issues/33662#issuecomment-2299180561
      commandLineArgs = [
        # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium%20/%20Electron
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"

        "--password-store=gnome"
        "--enable-zero-copy"

        # Source: https://github.com/fcitx/fcitx5/issues/263asdfasd (for fcitx support)
        "--gtk-version=4"
        "--enable-features=WebRTCPipeWireCapturer"

        # https://aur.archlinux.org/packages/ungoogled-chromium 2022-05-06 pinned message
        "--disable-features=UseChromeOSDirectVideoDecoder"
        "--enable-hardware-overlays"
      ];
    };
  };

  # Package Leftover
  home.packages = with pkgs; [
    ## Natural language
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en-us-large

    ## Daily Software
    libreoffice-fresh
    obsidian
    # Options from laptop to get fcitx5 input working:
    # --enable-features=WaylandWindowsDecorations,UseOzonePlatform --ozone-platform-hint=wayland
    logseq
    anki
    #birdtray # Actually not needing this
    # FIXME https://gitlab.gnome.org/GNOME/glib/-/issues/3690
    planify
    nextcloud-client # Basically redundant, but still necessary for .desktop file in NIX_PATH...

    ## Privacy
    keepassxc
    tor-browser
    gpa
    magic-wormhole

    ## Chat Clients
    element-desktop
    telegram-desktop
    signal-desktop
    threema-desktop
    teams-for-linux
    vesktop
    protonmail-bridge-gui
    # https://github.com/NixOS/nixpkgs/issues/365156
    protonmail-desktop
    protonvpn-gui

    chromium-app-t3-chat

    ## Media
    kooha
    helvum
    vlc
    system-config-printer # graphical ui for CUPS
    transmission_4-gtk
    yt-dlp
    media-downloader # for yt-dlp
    cider
    localsend

    ## Images
    krita

    ### PDF
    pdfslicer
    qpdf

    google-chrome
  ];
}
