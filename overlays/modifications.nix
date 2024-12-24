{ inputs, ... }:

final: prev: {
  discord-modified = prev.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  oh-my-zsh-git = prev.pkgs.oh-my-zsh.overrideAttrs (with inputs; oldAttrs: {
    name = "oh-my-zsh-git";
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
      rev = "6df84d71fe8b532b6e1d7c4a754ea6c7c032f553";
      sha256 = "13kravicdhcq30n810cw3lv890q0hba44ic804zl8dmzjd73wvql";
    };
    version = "unstable-2024-07-05";
  });

  zsh-forgit-patched = prev.zsh-forgit.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "wfxr";
      repo = "forgit";
      rev = "8b60a899f49839992cb11a34a0dc7e562a71a0d4";
      sha256 = "0wlv3m79kskc4zz8iv5yv07gxraga34xm3qpxabpf11mxq92f27i";
    };
    version = "unstable-2024-08-15";
    postPatch = ''
      sed -i "/# determine installation path/,/fi/d" forgit.plugin.zsh
      substituteInPlace forgit.plugin.zsh \
        --replace "\$FORGIT_INSTALL_DIR/bin/git-forgit" "$out/bin/git-forgit"
    '';
    installPhase = (builtins.replaceStrings [ "install -D completions/git-forgit.zsh $out/share/zsh/zsh-forgit/git-forgit.zsh\n" ] [ "" ] oldAttrs.installPhase);
  });


  # Fixes

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
