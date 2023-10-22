{ pkgs, ... }:

{
  dconf.settings = { # TODO does this work?
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.packages = with pkgs; [
    virt-manager
    virt-viewer # TODO what's this exacltly?
  ];
}