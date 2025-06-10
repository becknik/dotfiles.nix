{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "t3-chat";
  categories = [
    "Chat"
  ];
  desktopName = "T3 Chat";
  url = "https://t3.chat";
  icon = ./t3-icon.png;
}
