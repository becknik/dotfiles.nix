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
    flags = (builtins.map
      (flakeInput: "--update-input ${flakeInput}")
      (lib.filter (name: name != "self") (lib.attrsets.mapAttrsToList (name: _: name) inputs))
    ) ++ [
      "-L" # print build logs
      "--commit-lock-file"
    ];
    dates = "Sat";
    randomizedDelaySec = "2h";
  };

  networking.hostName = "dnix";
  environment.variables."NIXOS_CONFIGURATION_NAME" = config.networking.hostName;

  # Source: https://github.com/NixOS/nixpkgs/issues/54707
  # The following only makes sense when building huge packages like the Linux kernel is failing with something like
  # `fatal error: error writing to /build/ccGD5Lsd.s: No space left on device`
  boot = {
    tmp.tmpfsSize = "90%"; # at least: max{linux-2023-11-25: 20G}
    kernelPackages = pkgs.linux_xanmod_latest_patched_dnix;
  };

  # Build Cache
  programs.ccache = {
    enable = false; # TODO "self.ccacheStdenv" breaks thing with fastStdenv
    /* packageNames = [
      "gcc-wrapper"
      "gcc"
      "xgcc"
      "gfortran" # why does this even exist? ...

      "clang"
      "llvm"

      "ghc" # this package is huge & builds forever!

      "linux"
    ]; */
  };

  nix.settings = {
    max-jobs = 3;
    cores = 7;

    system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ]
      # Source: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix.nix
      ++ [ "gccarch-alderlake" ];
    # TODO alderlake flag is available in GCC 13.1, but not sure how to change the system env compiler from gcc (12.3.1) to gcc13...
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
}
