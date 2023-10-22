{ ... }:

{
  ## TODO Default Apps
  # I'm confused...
  # Discourse thread: https://discourse.nixos.org/t/where-are-desktop-files-located/17391/6
  # echo $XDG_DATA_DIRS
  # less /etc/profiles/per-user/jnnk/share/applications/mimeinfo.cache
  # less /run/current-system/sw/share/applications/mimeinfo.cache
  # https://mimetype.io/all-types
  # https://unix.stackexchange.com/questions/114075/how-to-get-a-list-of-applications-associated-with-a-file-using-command-line

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "nvim.desktop" ]; # TODO might this cause dolphin to not open neovim properly?
      #"application/pdf" = ["org.gnome.Evince.desktop"];
    };
  };
}