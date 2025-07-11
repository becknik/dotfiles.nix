{ lib, pkgs, ... }:

# Source: https://github.com/nix-community/home-manager/issues/3447 (TODO seems like this isn't a real solution...)
let
  autostart-programs = with pkgs; [
    thunderbird
    #keepassxc
    #element-desktop # works, but launches the application without the `--hidden` flag...
    # telegram-desktop
    # signal-desktop
    # planify
  ];
in
{
  home.file =
    (builtins.listToAttrs (
      map (pkg: {
        name = ".config/autostart/${pkg.pname}.desktop";
        value =
          if pkg ? desktopItem then
            {
              # Application has a desktopItem entry.
              # Assume that it was made with makeDesktopEntry, which exposes a
              # text attribute with the contents of the .desktop file
              text = pkg.desktopItem.text;
            }
          else
            {
              # Application does *not* have a desktopItem entry. Try to find a
              # matching .desktop name in /share/apaplications
              source = (pkg + "/share/applications/${pkg.pname}.desktop");
            };
      }) autostart-programs
    ))
    # Manual File Creation
    // (with pkgs; {
      "${element-desktop.pname}" = {
        enable = true;
        target = ".config/autostart/${element-desktop.pname}.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Name=${element-desktop.pname}
          Exec=${lib.getExe element-desktop} --hidden
          StartupNotify=false
          Terminal=false
          X-GNOME-Autostart-enabled=true
        '';
      };
      "${signal-desktop.pname}" = {
        enable = true;
        target = ".config/autostart/${signal-desktop.pname}.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Name=${signal-desktop.pname}
          Exec=${
            builtins.concatStringsSep " " [
              (lib.getExe signal-desktop)
              "--use-tray-icon"
              "--start-in-tray"
              "--no-sandbox"
              "%U"
            ]
          }
          X-GNOME-Autostart-enabled=true
        '';
      };

      "${protonmail-bridge-gui.pname}" = {
        enable = true;
        target = ".config/autostart/${protonmail-bridge-gui.pname}.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Name=${protonmail-bridge-gui.pname}
          Exec=env QT_PLUGIN_PATH=${kdePackages.qtwayland}/lib/qt-6/plugins QML_IMPORT_PATH=${kdePackages.qtdeclarative}/lib/qt-6/qml:${kdePackages.qtquicktimeline}/lib/qt-6/qml/${kdePackages.qtsvg}:/lib/qt-6/plugins ${protonmail-bridge-gui}/lib/bridge-gui --no-window
          X-GNOME-Autostart-enabled=true
        '';
      };

      "${vesktop.pname}.desktop" = {
        enable = true;
        target = ".config/autostart/${vesktop.pname}.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Name=${element-desktop.pname}
          Exec=${
            builtins.concatStringsSep " " [
              (lib.getExe electron)
              "${vesktop}/opt/Vesktop/resources/app.asar"
              "--enable-speech-dispatcher"
              "--enable-blink-features=MiddleClickAutoscroll"
              "--ozone-platform-hint=auto"
              "--enable-features=WaylandWindowDecorations"
              "--enable-wayland-ime"
              "--start-minimized"
            ]
          }
          StartupNotify=false
          Terminal=false
          X-GNOME-Autostart-enabled=true
        '';
      };

      "${planify.pname}.desktop" = {
        enable = true;
        target = ".config/autostart/${planify.pname}.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Name=Planify
          Exec=${lib.getExe planify} --background
          StartupNotify=true
          Terminal=false
          X-GNOME-Autostart-enabled=true
        '';
      };
    });
}
