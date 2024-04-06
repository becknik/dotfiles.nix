{ ... }:

final: prev: {
  discord-modified = prev.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  oh-my-zsh-git = prev.pkgs.oh-my-zsh.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "0fed36688f9a60d8b1f2182f27de7fdc8a1e6b72";
      sha256 = "1fc6d3svc6iq8bblr9f9m8izx32ph6slsdmlg4iln93gaz7c6gwk";
    };
    version = "unstable-2024-03-16";
  });

  pure-prompt-patched = prev.pure-prompt.overrideAttrs (oldAttrs: {
    patches = [ ./modifications/pure-prompt.patch ];
  });

  fzf-git-sh-patched = prev.unstable.fzf-git-sh.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf-git.sh";
      rev = "2b93e957684f7daca8b28cb74c9a7e7fc606e81e";
      sha256 = "1mpm4v3393dr5720ik9x6wr87md1ch2sq1dd43bs26dh3v1p38fh";
    };
    version = "unstable-2024-02-17";
    patches = [ ./modifications/fzf-git-sh-feat-vim-keybindings.patch ];
  });

  zsh-forgit-patched = prev.zsh-forgit.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "wfxr";
      repo = "forgit";
      rev = "2436fc4e11dd39dd0c795edb8304b8694a9ba96d";
      sha256 = "015v72dqzjn3gbhyzq2qic9rmyc5g8q32r4d232m3f3pdhfr0w8f";
    };
    version = "unstable-2024-03-14";
    postPatch = ''
      sed -i "/# determine installation path/,/fi/d" forgit.plugin.zsh
      substituteInPlace forgit.plugin.zsh \
        --replace "\$FORGIT_INSTALL_DIR/bin/git-forgit" "$out/bin/git-forgit"
    '';
    installPhase = (builtins.replaceStrings [ "install -D completions/git-forgit.zsh $out/share/zsh/zsh-forgit/git-forgit.zsh\n" ] [ "" ] oldAttrs.installPhase);
  });

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

  # Own Packages

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
