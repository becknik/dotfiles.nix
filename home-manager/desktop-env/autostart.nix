{ pkgs, ... }:

# Source: https://github.com/nix-community/home-manager/issues/3447 (TODO seems like this isn't a real solution...)
let
  autostartPrograms = with pkgs; [
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
  home.file = builtins.listToAttrs (map
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
    autostartPrograms);
}