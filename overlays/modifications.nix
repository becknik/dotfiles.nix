{ inputs, ... }:

final: prev: {
  discord-modified = prev.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  oh-my-zsh-git = prev.pkgs.oh-my-zsh.overrideAttrs (with inputs; oldAttrs: {
    version = ohmyzsh.rev;
    src = ohmyzsh;
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

  auto-cpufreq = with prev; auto-cpufreq.overrideAttrs (oldAttrs: {
    # https://github.com/AdnanHodzic/auto-cpufreq/issues/661
    patches = oldAttrs.patches ++ [ ./modifications/auto-cpufreq_pipe-log-spam.patch ];
  });


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

        MRAPTORLAKE = yes;
      };
      # Disable errors in console compilation log
      ignoreConfigErrors = true;
    })
  );

  # https://wiki.archlinux.org/title/ASUS_Zenbook_UM3402YA
  linux_xanmod_latest_patched_lnix = prev.pkgs.linuxPackagesFor (
    prev.pkgs.linux_xanmod_latest.override (old: with prev.lib; {
      kernelPatches = [ ];
      structuredExtraConfig = with kernel; {
        DEBUG_KERNEL = mkDefault no;
        NUMA = mkDefault no;
        WINESYNC = no;

        MZEN3 = yes;
      };
      ignoreConfigErrors = true;
    })
  );
}
