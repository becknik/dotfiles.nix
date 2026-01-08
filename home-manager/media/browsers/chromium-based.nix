{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.unstable.ungoogled-chromium;
    # works for chromium now, but doesn't for electron: https://github.com/electron/electron/issues/33662#issuecomment-2299180561
    commandLineArgs = [
      # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium%20/%20Electron
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"

      "--password-store=gnome"
      "--enable-zero-copy"

      # Source: https://github.com/fcitx/fcitx5/issues/263asdfasd (for fcitx support)
      "--gtk-version=4"
      "--enable-features=WebRTCPipeWireCapturer"

      # https://aur.archlinux.org/packages/ungoogled-chromium 2022-05-06 pinned message
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--enable-hardware-overlays"

      "--force-prefers-no-reduced-motion"
    ];
  };

  home.packages = with pkgs; [
    google-chrome
  ];
}
