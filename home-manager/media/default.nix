{
  pkgs,
  ...
}:

{
  imports = [
    ./browsers
    ./mail.nix
    ./thunderbird.nix

    ./gpg.nix

    ./flameshot.nix
  ];

  # Sync
  services = {
    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };

  programs.mpv.enable = true;

  home.packages = with pkgs; [
    ## Natural language
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en-us-large

    ## Daily Software
    libreoffice-fresh
    obsidian
    logseq
    unstable.anki
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
    chromium-app-t3-chat

    protonmail-bridge-gui
    protonmail-desktop
    protonvpn-gui

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
  ];
}
