{ inputs, mkFlakeDir, userName, config, lib, pkgs, ... }:

{
  imports = [
    ../../disko/ext4-unencrypted.nix

    ./hardware-configuration.nix
  ];

  system.autoUpgrade = {
    enable = true;
    operation = "boot";
    flake = (mkFlakeDir userName config);
    flags = [
      "-L" # print build logs - interesting in combination with nix-output-monitor || hacks from ../systemd.nix
      # `tail -n +1 -f .log |& nom`
    ];
    dates = "Sat *-*-* 8:00";
    randomizedDelaySec = "20m";
  };
  # https://git.lix.systems/lix-project/lix/issues/400
  systemd.services.nixos-upgrade.preStart = "nix flake update --flake ${mkFlakeDir userName config} --commit-lock-file";

  networking.hostName = "dnix";
  environment.variables."FLAKE_NIXOS_HOST" = config.networking.hostName;

  # Source: https://github.com/NixOS/nixpkgs/issues/54707
  # The following only makes sense when building huge packages like the Linux kernel is failing with something like
  # `fatal error: error writing to /build/ccGD5Lsd.s: No space left on device`
  boot = {
    tmp.tmpfsSize = "90%"; # at least: max{linux-2023-11-25: 20G}
    kernelPackages = pkgs.linux_xanmod_latest_patched_dnix;
  };

  nix.settings = {
    max-jobs = 3;
    cores = 7;

    # system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ]
    # Source: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix.nix
    # ++ [ "gccarch-alderlake" ]; # TODO raptorlake needs to be added to architectures.nix for this to work (?)
  };

  # Arch Linux compilation flags setup
  #CFLAGS="-march=native -O3 -pipe -fno-plt -fexceptions \
  #        -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
  #        -fstack-clash-protection -fcf-protection"
  #CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
  #LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
  #LTOFLAGS="-flto=auto"
  #RUSTFLAGS="-C opt-level=3 -C target-cpu=native"
  #-- Make Flags: change this for DistCC/SMP systems
  #MAKEFLAGS="-j12"

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    # sadly, this still compiles some i686 dependencies...
    package = (pkgs.steam.override { withGameSpecificLibraries = false; });
  };
}
