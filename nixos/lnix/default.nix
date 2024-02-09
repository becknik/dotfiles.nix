{ config, pkgs, ... }:

{
  imports = [
    ../../disko/ext4-encrypted.nix

    ./hardware-configuration.nix
  ];

  environment.variables."NIXOS_CONFIGURATION_NAME" = config.networking.hostName;

  #boot.kernelPackages = pkgs.linuxPackages_xanmod_latest_patched_lnix;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;


  networking = {
    hostName = "lnix";

    /* wireless = {
      enable = true;
      userControlled = {
        enable = true;
        group = "network";
      };
      allowAuxiliaryImperativeNetworks = true;
    }; */
    networkmanager.wifi = {
      powersave = true;
      scanRandMacAddress = true;

      macAddress = config.networking.networkmanager.ethernet.macAddress; # = "stable"
    };
  };

  systemd.network.wait-online.anyInterface = true; # Whether to consider the network online when any interface is online

  ## Logind
  # TODO Logind config might be interesting for laptops https://man7.org/linux/man-pages/man5/logind.conf.5.html
}
