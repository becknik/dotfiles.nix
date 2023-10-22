{ ... }:

{
  programs.librewolf = { # TODO No advanced firefox options are available here...
    enable = true;
    settings = {
      "media.ffmpeg.vaapi.enabled" = true;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "browser.gnome-search-provider.enabled" = true;
      "browser.tabs.loadBookmarksInTabs" = true;
      "browser.compactmode.show" = true;
    };
  };
}