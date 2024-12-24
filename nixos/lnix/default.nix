{ config, pkgs, lib, ... }:

{
  imports = [
    ../../disko/ext4-encrypted.nix

    ./hardware-configuration.nix
  ];

  environment.variables."FLAKE_NIXOS_HOST" = config.networking.hostName;

  nix.settings = {
    max-jobs = 2;
    cores = 4;
  };

  boot = {
    tmp.tmpfsSize = "80%";
    # kernelPackages = pkgs.linux_xanmod_latest_patched_lnix;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };


  networking = {
    hostName = "lnix";

    networkmanager = {
      wifi = {
        powersave = false;
        scanRandMacAddress = false;

        macAddress = config.networking.networkmanager.ethernet.macAddress; # = "stable"
      };
    };
  };
  boot.extraModprobeConfig = "options mt7921e power_save=0";

  systemd.network.wait-online.anyInterface = false; # whether to consider the network online when any interface is online
  # Lets the nixos-fetch-flake.service fail


  # Power Management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # https://github.com/AdnanHodzic/auto-cpufreq
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  # conflicting with auto-cpufreq
  services.power-profiles-daemon.enable = lib.mkForce false;

  ## Logind
  # TODO Logind config might be interesting for laptops https://man7.org/linux/man-pages/man5/logind.conf.5.html

  services.keyd = {
    enable = true;
    keyboards."laptop-keyboard" = {
      ids = [ "k:04F3:31B9" "0001:0001" ]; # 0001:0001 AT Translated Set 2 keyboard (/dev/input/event0)
      # I'm guessing that the 0001:0001 id is necessary due to fcitx5?
      settings = {
        main = {
          capslock = "overload(nav, esc)";
          # TODO not optimal due to accidental long press https://manpages.opensuse.org/Tumbleweed/keyd/keyd.1.en.html
          # rightshift = "overload(shift, capslock)";
        };
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };
}
