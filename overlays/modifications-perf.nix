{ ... }:

final: prev: {
  python3 = prev.python3.override {
    reproducibleBuild = false;
    enableOptimizations = true;
  };

  librewolf-unwrapped = prev.librewolf-unwrapped.overrideAttrs (oldAttrs:
    let
      # Source: https://firefox-source-docs.mozilla.org/setup/configuring_build_options.html
      configureFlags' = prev.lib.lists.subtractLists [ "--enable-debug-symbols" ] oldAttrs.configureFlags;
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
      configureFlags = configureFlags'';
      preConfigure = oldAttrs.preConfigure + "export RUSTFLAGS=\"-C debuginfo=0 -C target-cpu=native -C opt-level=3\"\n";
    });

  ## Linux Kernel

  linux_xanmod_latest_patched_dnix = prev.pkgs.linuxPackagesFor (
    prev.pkgs.linux_xanmod_latest.override (old: with prev.lib; {

      # TODO https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=linux-clear
      kernelPatches = [ ];

      # Maybe interesting: https://discourse.nixos.org/t/overriding-nativebuildinputs-on-buildlinux/24934
      structuredExtraConfig = with kernel; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/xanmod-kernels.nix
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/common-config.nix
        DEBUG_KERNEL = mkDefault no;
        NUMA = mkDefault no;
        WINESYNC = no;
        MALDERLAKE = yes; # TODO GCC13 -> MRAPTORLAKE GENERIC_CPU3
      };
      # Disable errors in console compilation log
      ignoreConfigErrors = true;
    })
  );

  linux_xanmod_latest_patched_lnix = prev.pkgs.linuxPackages_xanmod_latest;
  /* pkgs.linuxPackagesFor (
      pkgs.linux_xanmod_latest.override (old: {
        # TODO https://wiki.archlinux.org/title/ASUS_Zenbook_UM3402YA
        kernelPatches = [ ];
        ignoreConfigErrors = true;
      })
    ); */
}