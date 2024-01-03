{ pkgs, ... }:

# Source: https://github.com/nix-community/home-manager/issues/3447 (TODO seems like this isn't a real solution...)
let
  autostart-programs = with pkgs; [
    thunderbird
    #keepassxc
    #element-desktop # works, but launches the application without the `--hidden` flag...
    #telegram-desktop
    signal-desktop
    #whatsapp-for-linux
    discord
    #teams-for-linux
    #planify
  ];
in
{
  home.file = (builtins.listToAttrs (map
    (pkg:
      {
        name = ".config/autostart/${pkg.pname}.desktop";
        value =
          if pkg ? desktopItem then {
            # Application has a desktopItem entry.
            # Assume that it was made with makeDesktopEntry, which exposes a
            # text attribute with the contents of the .desktop file
            text = pkg.desktopItem.text;
          } else {
            # Application does *not* have a desktopItem entry. Try to find a
            # matching .desktop name in /share/apaplications
            source = (pkg + "/share/applications/${pkg.pname}.desktop");
          };
      })
    autostart-programs)) // {

    # Manual File Creation

    ## The element-internal way of generating an `electron.desktop` file is generally wrong and
    # also incompatible with NixOS due to dangling symlinks...
    # TODO Patch for element-desktop to be NixOS-friendlier?
    "element-desktop-autostart" = {
      enable = true;
      target = ".config/autostart/element.desktop";
      text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        Name=Element
        Comment=Forcing element-desktop to start properly
        Exec=element-desktop --hidden
        StartupNotify=false
        Terminal=false
      '';
    };

    "whatsapp-for-linux-autostart" = {
      enable = true;
      target = ".config/autostart/whatsapp-for-linux.desktop";
      text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        Name=Whatsapp
        Comment=Fixing the autostart toggle of whatsapp-for-linux doing nothing at all
        Exec=whatsapp-for-linux
        StartupNotify=false
        Terminal=false
      '';
    };
  };
}
