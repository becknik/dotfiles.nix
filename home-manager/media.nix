{ pkgs, ... }:

{
  imports = [
    #./media/mail.nix # TODO home-manager account integration won't work with thunderbird...

    ./programs/librewolf.nix
  ];

  # Multimedia
  services.easyeffects.enable = true;
  programs.mpv.enable = true;

  services = {
    # Sync
    nextcloud-client = {
      # TODO implement sync-exclude.lst management
      enable = true;
      startInBackground = true;
      package = pkgs.nextcloud-client;
    };
    #dropbox.enable = true; # TODO dropbox
    # Privacy
    #keychain # TODO keychain management methods
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
  programs.gpg.enable = true;

  programs = {
    # Browsers
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--features=UseOzonePlatform"
        "--ozone-platform-hint=wayland"
        "--password-store=gnome"
        "--enable-zero-copy"

        # https://aur.archlinux.org/packages/ungoogled-chromium 2022-05-06 pinned message
        "--disable-features=UseChromeOSDirectVideoDecoder"
        "--enable-hardware-overlays"

          #--process-per-site
          #-single-process
          #-force-device-scale-factor=1
          #--disable-reading-from-canvas
          # GUP - ArchWiki
          #--ignore-gpu-blocklist
          #--enable-gpu-rasterization
          #--disable-gpu-driver-bug-workarounds
          #--enable-features=VaapiVideoDecoder
          #--disable-features=UseChromeOSDirectVideoDecoder
      ];
    };
    # Mail
    thunderbird = {
      enable = true;
      profiles."default" = {
        isDefault = true;
        withExternalGnupg = true;
      };

      settings = {
        "privacy.donottrackheader.enabled" = true;
      };
    };
  };


  # Package Leftover
  home.packages = with pkgs; [
    ## Natural language
    hunspell
    hunspellDicts.de_DE

    ## Daily Software
    libreoffice-still
    unstable.obsidian
    birdtray # TODO does this work?
    unstable.planify
    nextcloud-client # TODO basically redundant, but necessary for .desktop file in NIX_PATH...

    ## Privacy
    keepassxc
    unstable.tor-browser # same version under tor-browser-bundle-bin in 23.05
    gpa

    ## Chat Clients
    element-desktop
    telegram-desktop
    signal-desktop
    whatsapp-for-linux
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    teams-for-linux

    ## Media
    kooha
    pavucontrol
    helvum
    vlc
    pdfslicer
    system-config-printer # graphical ui for CUPS
    transmission-gtk
    trash-cli
    yt-dlp
    media-downloader # for yt-dlp
    krita
  ];
}