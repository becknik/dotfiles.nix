{ config, lib, pkgs, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    system76-scheduler
    perf
    turbostat
    cpupower
  ];

  nixpkgs = {
    overlays = [
      (final: prev: {
        linux_xanmod_latest_custom = pkgs.linuxPackagesFor (pkgs.linux_xanmod_latest.override (old: {
          # Optimizations
          # TODO https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=linux-clear
          # Maybe interesting: https://discourse.nixos.org/t/overriding-nativebuildinputs-on-buildlinux/24934
          stdenv = prev.impureUseNativeOptimizations prev.stdenv;
          # Disable the Proton and Wine stuff
          structuredExtraConfig = with lib.kernel; {
            FUTEX = no;
            FUTEX_PI = no;
            WINESYNC = no;
          };
          # Disable programming language errors in the compilation-log
          ignoreConfigErrors = true;
        }));
      })
    ];
  };
}