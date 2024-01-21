{ config, lib, pkgs, ... }:

{
  imports = [
    #./media/mail.nix # TODO home-manager account integration won't work with thunderbird...

    #./programs/librewolf.nix
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

  programs = {
    # Browsers
    chromium = {
      enable = true;
      package = pkgs.clean.ungoogled-chromium;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
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
  home.packages = with pkgs; let
    # NixOS/nixpkgs#272912 NixOS/nixpkgs#273611
    elelctron_25-patched-for-wayland = pkgs.electron_25.overrideAttrs (_: {
      preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron";
    });
  in
  [
    ## Natural language
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en-us-large

    ## Daily Software
    clean.libreoffice-fresh
    (lib.trivial.throwIf (lib.strings.versionOlder "1.6" obsidian.version) "Obsidian no longer requires EOL Electron"
      (obsidian.override { electron = elelctron_25-patched-for-wayland; })
    )
    # Options from laptop to get fcitx5 input working:
    # --enable-features=WaylandWindowsDecorations,UseOzonePlatform --ozone-platform-hint=wayland
    (lib.trivial.throwIf (lib.strings.versionOlder "0.9.20" logseq.version) "logseq no longer requires EOL Electron"
      (logseq.override { electron_25 = elelctron_25-patched-for-wayland; })
    )
    #birdtray # Actually not needing this
    planify
    nextcloud-client # Basically redundant, but still necessary for .desktop file in NIX_PATH...

    ## Privacy
    keepassxc
    clean.tor-browser
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
    clean.krita
    imagemagick
  ];
}
