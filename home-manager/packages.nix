{ system, pkgs, ... }:

{
  # Btop
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "flat-remix.theme";
      theme_background = false;
      vim_keys = true;
      update_ms = 2500;
      proc_sorting = "cpu direct";
      proc_per_core = true;
      proc_filter_kernel = true;
      show_io_stat = false;
      io_mode = true;
    };
  };

  # Manual Installations
  home.packages =
    let
      isNotDarwin = (system != "x86_64-darwin");
      dummyPkg = pkgs.hello;
      makeWhenNotDarwin = pkg: (if isNotDarwin then pkg else dummyPkg) ;
    in
    with pkgs; [

      ## Utils
      jq
      curl
      ripgrep
      unzip
      tldr
      tree
      bat

      ### desktop-env
      (makeWhenNotDarwin wl-clipboard)

      ### Hardware
      cpufetch
      (makeWhenNotDarwin gparted)
      (makeWhenNotDarwin ventoy-full)
      (makeWhenNotDarwin powertop)

      ## NixOS
      nixos-option

      ### Secrets Management (1)
      sops
      age
      #age-plugin-yubikey # This isn't working with sops-nix atm due to sops... https://github.com/Mic92/sops-nix/issues/377
      (makeWhenNotDarwin yubikey-manager-qt)
      (makeWhenNotDarwin yubikey-personalization-gui)

      ## Penetration Testing
      nmap

      ## Benchmarking
      speedtest-cli
      stress-ng
      valgrind
      (makeWhenNotDarwin sysstat)

      ## Uni & TeX
      (makeWhenNotDarwin pandoc)
      (makeWhenNotDarwin gnuplot)
      (makeWhenNotDarwin qtikz)
      marp-cli

      ## Trash
      neofetch
      cmatrix
      fortune
      sl
      cbonsai
      (makeWhenNotDarwin oneko)
      uwuify
      #uwufetch # TODO uwufetch seems to be broken
    ];

  # Missing packages in nixpkgs:
  # - qtqr (replaced)
  # - gogh-git (workaround with dconf)
  # - zsh-lovers
  # - laptop-mode-tools
  # - modprobed-db
  # - plymouth-themes
  # - deezer: TODO https://github.com/Shawn8901/nix-configuration/blob/main/packages/deezer/default.nix

  # Packages I found unnecessary with nix shell:
  # [ mypy perf plantuml postgresql prettier(d)? ]
}
