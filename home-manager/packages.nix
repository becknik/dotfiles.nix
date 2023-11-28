{ pkgs, ... }:

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
  home.packages = with pkgs; [

    ## Utils
    jq
    curl
    ripgrep
    unzip
    tldr
    tree
    bat

    ### desktop-env
    wl-clipboard

    ### hardware
    cpufetch
    gparted
    ventoy
    powertop

    ## NixOS
    nixos-option
    unstable.nixd # TODO figure out how to set this up to work properly - should be superior to nil
    unstable.nil

    ### Secrets Management
    sops
    age
    #age-plugin-yubikey # This isn't working with sops-nix atm due to sops... https://github.com/Mic92/sops-nix/issues/377
    yubikey-manager-qt
    yubikey-personalization-gui

    ## Penetration Testing
    nmap

    ## Benchmarking
    speedtest-cli
    stress-ng
    sysstat
    valgrind

    ## Uni & TeX
    gnuplot
    pandoc
    qtikz
    texlive.combined.scheme-small # Need xelatex which is included right here
    unstable.anki
    unstable.marp-cli

    ## Trash
    neofetch
    cmatrix
    fortune
    sl
    cbonsai
    oneko
    uwuify
    #uwufetch # TODO broken?
  ];

  # Packages I found unnecessary with nix shell:
  # [ mypy perf plantuml postgresql prettier(d)? ]

  # TODO Missing packages:
  # [ qtqr, zsh-lovers, deezer, gogh-git, jetbrains-toolbox, laptop-mode-tools, modprobed-db, plymouth-themes ]
}