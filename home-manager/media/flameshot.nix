{ lib, pkgs, ... }:

let
  flameshotCommand = "sh -c '${lib.getExe pkgs.flameshot} gui --raw | wl-copy'";
  flameshotCommandName = "Flameshot";
in
{
  services.flameshot.enable = true;
  home.packages = with pkgs; [ wl-clipboard ];

  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = flameshotCommandName + " 1";
      command = flameshotCommand;
      binding = "<Alt>S";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = flameshotCommandName + " 2";
      command = flameshotCommand;
      binding = "Print";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
  };
}
