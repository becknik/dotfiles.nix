{ ... }:

{
  xdg.configFile."mimeapps.list".force = true;
  #xdg.configFile."mimeapps.list".mutable = true;

  xdg.mimeApps = {
    enable = true;

    # https://www.iana.org/assignments/media-types/media-types.xhtml
    # xdg-mime query filetype ~/dl/2024.07.04_Rechnung_Kundennr_923412501.pdf
    # xdg-mime query default 'application/pdf'
    # gtk-launch org.kde.okular.desktop
    defaultApplications = {
      "text/plain" = [ "nvim.desktop" ];

      "x-scheme-handler/sms" = [ "org.gnome.Shell.Extensions.GSConnect.desktop" ];
      "x-scheme-handler/tel" = [ "org.gnome.Shell.Extensions.GSConnect.desktop" ];

      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "x-scheme-handler/about" = [ "librewolf.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" ];
      "text/html" = [ "librewolf.desktop" ];

      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];

      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/jepg" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];

      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];

      "application/pdf" = [ "org.kde.okular.desktop" ];
    };
  };
}
