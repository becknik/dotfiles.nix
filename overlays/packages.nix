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

  # Something here makes the browsing experience really bad...
  patched-librewolf-unwrapped = final: prev: {
    librewolf-wayland = prev.clean.librewolf-wayland;
    librewolf-unwrapped = prev.librewolf-unwrapped.overrideAttrs (oldAttrs:
      let
        # Source: https://firefox-source-docs.mozilla.org/setup/configuring_build_options.html
        configureFlags' = with lib.lists; remove "--enable-optimize" (remove "--enable-debug-symbols" oldAttrs.configureFlags);
        # --enable-default-toolkit=cairo-gtk3-wayland --enable-lto=cross
        configureFlags'' = configureFlags' ++ [ "--disable-debug-symbols" "--enable-optimize=-march=native" "--enable-optimize=-O3" "--enable-rust-simd" ]; # When specified multiple times the last option is applied by mozbuild
        # "--enable-profile-use=cross"
        # ''--enable-optimize="-march=native -O2"'' doesn't work due to '\' not being removed by nix...
        # "--enable-default-toolkit=cairo-gtk3-wayland-only": crashes in profiling phase
        # "--enable-lto=cross,full": to much RAM usage...
      in
      {
        makeFlags = oldAttrs.makeFlags ++ [ "-j 18" ];
        configureFlags = configureFlags'';
        #depsBuildBuild = [ pkgs.egl-wayland ];
        preConfigure = oldAttrs.preConfigure + "RUSTFLAGS=\"-C debuginfo=0 -C target-cpu=native -C opt-level=3\"\n";
      });
  };

  obsidian = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      depsHostHost = [ pkgs.egl-wayland ];
    });
  };
}
