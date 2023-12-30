{ pkgs, lib, ... }:

{
  default-to-faster-stdenv = final: prev: {
    #stdenv = prev.fastStdenv;
    fastStdenv.mkDerivation = {
      # https://nixos.wiki/wiki/C#Faster_GCC_compiler (don't really know if this works...)
      name = "env";
    };
  };

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

  patched-librewolf-unwrapped = final: prev: {
    #librewolf-wayland = prev.clean.librewolf-wayland;
    librewolf-unwrapped = prev.librewolf-unwrapped.overrideAttrs (oldAttrs:
      let
        # Source: https://firefox-source-docs.mozilla.org/setup/configuring_build_options.html
        configureFlags' = with lib.lists; remove "--enable-debug-symbols" oldAttrs.configureFlags;
        # --enable-optimize --enable-default-toolkit=cairo-gtk3-wayland --enable-lto=cross
        configureFlags'' = configureFlags' ++ [ "--disable-debug-symbols" "--enable-rust-simd" ];
        # When option is specified multiple times the last option is applied by mozbuild
        # ''--enable-optimize="-march=native,-O3"'' doesn't work due to '\' not being removed from nix-string...
        # -> https://discourse.nixos.org/t/character-escaping-remove-from-escaped-string/37444
        # "--enable-default-toolkit=cairo-gtk3-wayland-only": crashes in profiling phase
        # "--enable-lto=cross,full": to much RAM usage...
      in
      {
        #depsBuildBuild = [ pkgs.egl-wayland ];
        #makeFlags = oldAttrs.makeFlags ++ [ "-j 20" ];
        configureFlags = configureFlags'';
        preConfigure = oldAttrs.preConfigure + "export RUSTFLAGS=\"-C debuginfo=0 -C target-cpu=native -C opt-level=3\"\n";
      });
  };

  obsidian = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      depsHostHost = [ pkgs.egl-wayland ];
    });
  };
}
