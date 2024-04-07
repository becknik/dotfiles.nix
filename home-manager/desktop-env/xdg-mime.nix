{ ... }:

{
  xdg.configFile."mimeapps.list".force = true;
  #xdg.configFile."mimeapps.list".mutable = true;

  # https://www.iana.org/assignments/media-types/media-types.xhtml
  # TODO globbing isn't supported by default...
  xdg.mimeApps =
    let
      assocations = {
        "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
        "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";

        "x-scheme-handler/http" = "librewolf.desktop;";
        "x-scheme-handler/https" = "librewolf.desktop;";
        "text/html" = "librewolf.desktop;";
        "application/xhtml+xml" = "librewolf.desktop;";

        "x-scheme-handler/mailto" = "thunderbird.desktop;";

        "image/*" = "org.kde.gwenview.desktop;";
        "video/*" = "vlc.desktop;";
        "audio/*" = "vlc.desktop;";
      };
    in
    {
      enable = true;
      associations.added = assocations;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
      } // assocations;
    };
}
