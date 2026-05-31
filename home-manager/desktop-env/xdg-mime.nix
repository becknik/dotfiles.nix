{ config, lib, ... }:

{
  xdg.configFile."mimeapps.list".force = true;
  #xdg.configFile."mimeapps.list".mutable = true;

  xdg.desktopEntries."kitty-editor" = {
    name = "Kitty Editor";
    exec = "${lib.getExe config.programs.kitty.package} sh -c \"${config.home.sessionVariables.EDITOR} %F\"";
    type = "Application";
    terminal = false;
    mimeType = [ "text/plain" ];
  };

  xdg.mimeApps = {
    enable = true;

    # https://www.iana.org/assignments/media-types/media-types.xhtml
    # xdg-mime query filetype ~/dl/2024.07.04_Rechnung_Kundennr_923412501.pdf
    # xdg-mime query default 'application/pdf'
    # gtk-launch org.kde.okular.desktop
    defaultApplications = {
      "text/plain" = [ "kitty-editor.desktop" ];

      "x-scheme-handler/sms" = [ "org.gnome.Shell.Extensions.GSConnect.desktop" ];
      "x-scheme-handler/tel" = [ "org.gnome.Shell.Extensions.GSConnect.desktop" ];

      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];
      "application/xhtml+xml" = [ "zen-beta.desktop" ];
      "x-scheme-handler/about" = [ "zen-beta.desktop" ];
      "x-scheme-handler/unknown" = [ "zen-beta.desktop" ];
      "text/html" = [ "zen-beta.desktop" ];

      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];

      "image/png" = [
        # "re.sonny.Junction.desktop"
        "org.kde.gwenview.desktop"
      ];
      "image/jpg" = [
        # "re.sonny.Junction.desktop"
        "org.kde.gwenview.desktop"
      ];
      "image/jpeg" = [
        # "re.sonny.Junction.desktop"
        "org.kde.gwenview.desktop"
      ];
      "image/webp" = [
        # "re.sonny.Junction.desktop"
        "org.kde.gwenview.desktop"
      ];
      "image/svg+xml" = [
        # "re.sonny.Junction.desktop"
        "org.kde.gwenview.desktop"
      ];

      "video/webm" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "video/vp9" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "video/vp8" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "video/ogg" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "video/mpeg" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "video/mpv" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "video/mp4" = [
        # "re.sonny.Junction.desktop"
        "mpv.desktop"
      ];
      "audio/*" = [ "mpv.desktop" ];

      "application/pdf" = [ "org.gnome.Papers.desktop" ];

      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/zstd" = [ "org.kde.ark.desktop" ];
      "application/gzip" = [ "org.kde.ark.desktop" ];

      "x-scheme-handler/file" = [ "re.sonny.Junction.desktop" ];
    };
  };
}
