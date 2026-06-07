{ pkgs
, ...
}:

{
  imports = [
    ./browsers
    ./mail.nix
    ./thunderbird.nix

    ./gpg.nix
  ];

  # Sync
  programs.mpv.enable = true;

  home.packages = with pkgs; [
    ## Natural language
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en-us-large

    ## Daily Software
    libreoffice-fresh
    unstable.obsidian
    logseq
    unstable.anki
    # https://github.com/alainm23/planify/issues/2232
    unstable.planify
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

    unstable.protonmail-bridge-gui
    unstable.protonmail-desktop
    unstable.proton-vpn
    unstable.proton-vpn-cli

    ## Media
    kooha
    crosspipe
    system-config-printer # graphical ui for CUPS
    transmission_4-gtk
    yt-dlp
    media-downloader # for yt-dlp
    localsend

    ## Images
    krita

    ### PDF
    qpdf
  ];
}
