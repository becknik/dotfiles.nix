{ config, pkgs, lib, ... }:

{
  imports = [
    ./media/gpg.nix

    ./media/mail.nix
    ./programs/thunderbird.nix
  ];

  # Multimedia
  #services.easyeffects.enable = true;
  programs.mpv.enable = true;

  services = {
    # Sync
    nextcloud-client = {
      enable = true;
      #startInBackground = true; # Keeps `Process 3436 (.nextcloud-wrap) of user 1000 dumped core.`-ing... - even after disabling, wtf?
      # However, after setting up nextcloud, the autostart .desktop-files is created automatically
    };
    /*dropbox = { # TODO Dropbox module not working & corresponding home-manager issue is on stall: https://github.com/nix-community/home-manager/issues/4226
      enable = true;
      path = "${config.home.homeDirectory}/dropbox";
    };*/
  };
  # ad-hoc disabling systemd service to avoid core-dumping
  systemd.user.services.nextcloud-client.Service.ExecStart = (lib.mkForce "");

  # Browsers

  home.file = {
    "gsconnect-librewolf-message-hosts" = {
      target = ".librewolf/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
      source = "${pkgs.gnomeExtensions.gsconnect}/lib/mozilla/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
      # Also available under /etc(/opt)?/chrome/native-messaging-hosts/
    };
    "keepassxc-proxy-for-librewolf-message-hosts" = {
      source = "${pkgs.keepassxc}/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
      target = ".librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
    };
  };

  programs = {
    librewolf = {
      enable = true;
      package = pkgs.librewolf-wayland.overrideAttrs (oldAttrs: {
        extraNativeMessagingHosts = (with pkgs; [ gnomeExtensions.gsconnect keepassxc ]);
      });
      # necessary file for keepassxc integration is created in `folders-and-files.nix`

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
        "webgl.disabled" = false; # Actually anti-privacy...
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
      package = pkgs.ungoogled-chromium;
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
    planify
    nextcloud-client # Basically redundant, but still necessary for .desktop file in NIX_PATH...

    ## Privacy
    keepassxc
    tor-browser
    gpa
    veracrypt # TODO derivation with set WXSUPPRESS_SIZER_FLAGS_CHECK env var

    ## Chat Clients
    element-desktop
    telegram-desktop
    signal-desktop
    threema-desktop
    teams-for-linux
    (vesktop.override {
      withMiddleClickScroll = true;
      withSystemVencord = true;
    })

    ## Media
    kooha
    pavucontrol
    helvum
    vlc
    system-config-printer # graphical ui for CUPS
    transmission_4-gtk
    trash-cli
    yt-dlp
    media-downloader # for yt-dlp
    unstable.cider
    localsend

    ## Images
    krita
    imagemagickBig

    ### PDF
    pdfslicer
    qpdf
    paper-clip # for editing PDF metadata

    google-chrome
  ];
}
