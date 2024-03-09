{ inputs, ... }:

final: prev: {
  oh-my-zsh-git = prev.pkgs.oh-my-zsh.overrideAttrs (with inputs; oldAttrs: {
    #version = ohmyzsh.shortRev or ohmyzsh.rev or self.shortRev or self.dirtyShortRev or self.lastModified or "unknown";
    #version = ohmyzsh.rev;
    src = ohmyzsh;
  });

  discord-modified = prev.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  # Fixes

  # NixOS/nixpkgs#272912 NixOS/nixpkgs#273611
  obsidian = with prev;
    (lib.trivial.throwIf (lib.strings.versionOlder "1.5.7" obsidian.version) "Obsidian no longer requires EOL Electron"
      (obsidian.override {
        electron = electron_25.overrideAttrs (oldAttrs: {
          preFixup = oldAttrs.preFixup or "" + "patchelf --add-needed ${prev.pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron";
        });
      })
    );

  logseq = with prev; logseq.override {
    electron_27 = electron_27.overrideAttrs (oldAttrs: {
      preFixup = oldAttrs.preFixup or "" + "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron";
    });
  };

  # Latest postman build fails to download
  #> curl: (22) The requested URL returned error: 404
  #> error: cannot download postman-10.18.6.tar.gz from any mirror
  postman =
    let version = "10.23.5";
    in prev.postman.overrideAttrs (oldAttrs: {
      inherit version;
      src =
        builtins.fetchurl {
          url = "https://dl.pstmn.io/download/version/${version}/linux64";
          sha256 = "sha256:0k02g57n7ywlic1bxygnigklbwc7x2hv6n6pdhbn5zgq7rzmnzil";
          name = "${prev.postman.pname}-${version}.tar.gz";
        };
    });

/*   dsseries = prev.dsseries.override {
    version =
    src = builtins.fetchurl {
      https://download.brother.com/welcome/dlf104036/brscan5-1.3.1-0.x86_64.rpm
      url = "https://dl.pstmn.io/download/version/${version}/linux64";
      sha256 = "sha256:0k02g57n7ywlic1bxygnigklbwc7x2hv6n6pdhbn5zgq7rzmnzil";
      name = "${prev.postman.pname}-${version}.tar.gz";
    };
  }; */

  # Performance

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
