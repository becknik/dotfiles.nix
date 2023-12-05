{ pkgs, ... }:

{
  dconf.settings = { # TODO does this work?
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

/*   home.packages = with pkgs; [ # TODO remove virt-manager from home-manager
    virt-manager
    virt-viewer # TODO what's this exacltly?
  ]; */
}