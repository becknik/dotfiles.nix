{ pkgs, lib, ... }:

{
  patched-linux = final: prev: {
    linux_xanmod_latest_patched = pkgs.linuxPackagesFor (
      pkgs.linux_xanmod_latest.override (old: {
        # Optimizations
        # TODO https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=linux-clear
        # Maybe interesting: https://discourse.nixos.org/t/overriding-nativebuildinputs-on-buildlinux/24934
        structuredExtraConfig = with lib.kernel; {
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/xanmod-kernels.nix
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/common-config.nix
          DEBUG_KERNEL = no;
          SUNRPC_DEBUG = no;
          SCHED_DEBUG = no;

          NUMA = no;

          FUTEX = no;
          FUTEX_PI = no;
          WINESYNC = no;
        };
        # Disable errors in console compilation log
        ignoreConfigErrors = true;
      }));
  };

  obsidian = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      depsHostHost = [ pkgs.egl-wayland ];
    });
  };
}
