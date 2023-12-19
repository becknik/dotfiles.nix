{ pkgs, lib, ... }:

{
  patched-linux = final: prev: {
    linux_xanmod_latest_patched = pkgs.linuxPackagesFor (
      pkgs.linux_xanmod_latest.override (old: {

        # TODO https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=linux-clear
        kernelPatches = [
          /*{
            # https://nixos.org/manual/nixpkgs/stable/#fetchpatch
            patch = (prev.fetchpatch {
              name = "patch-linux-kernel-more-uarches";
              url = "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.17%2B.patch";
              hash = "sha256-HPaB0/vh5uIkBLGZqTVcFMbm87rc9GVb5q+L1cHAE/o=";
            });
            extraConfig = "MALDERLAKE y "; #GENERIC_CPU3 MRAPTORLAKE
          }*/
        ];

        # Maybe interesting: https://discourse.nixos.org/t/overriding-nativebuildinputs-on-buildlinux/24934
        structuredExtraConfig = with lib.kernel; {
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/xanmod-kernels.nix
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/common-config.nix
          DEBUG_KERNEL = lib.mkDefault no;

          NUMA = lib.mkDefault no;

          WINESYNC = no;
        };
        # Disable errors in console compilation log
        ignoreConfigErrors = true;
      })
    );
  };

  obsidian = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      depsHostHost = [ pkgs.egl-wayland ];
    });
  };
}
