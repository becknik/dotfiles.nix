{ config, pkgs, ... }:

{
  imports = [
    #./media/mail.nix # TODO home-manager account integration won't work with thunderbird...

    ./programs/librewolf.nix
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
    libreoffice-still
    obsidian
    #birdtray # Actually not needing this
    planify
    nextcloud-client # Basically redundant, but still necessary for .desktop file in NIX_PATH...

    ## Privacy
    keepassxc
    tor-browser
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
    #teams-for-linux

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
