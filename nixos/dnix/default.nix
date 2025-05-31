{
  mkFlakeDir,
  userName,
  config,
  pkgs,
  ...
}:

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
    kernelPackages = pkgs.linux_xanmod_stable_patched_dnix;
  };

  nix.settings = {
    max-jobs = 2;
    cores = 4;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = true;
  };
}
