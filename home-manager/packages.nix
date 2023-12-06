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
    coreutils # for sha256sum

    ### desktop-env
    wl-clipboard

    ### hardware
    cpufetch

    ## NixOS
    nixos-option
    unstable.nixd # TODO figure out how to set this up to work properly - should be superior to nil
    unstable.nil

    ### Secrets Management
    sops
    age
    age-plugin-yubikey # TODO Buy one :)

    ## Penetration Testing
    nmap

    ## Benchmarking
    speedtest-cli
    stress-ng

    ## Trash
    neofetch
    cmatrix
    fortune
    sl
    cbonsai
    #oneko
    #uwuify
    #uwufetch # TODO broken?
  ];

  # Packages I found unnecessary with nix shell:
  # [ mypy perf plantuml postgresql prettier(d)? ]

  # TODO Missing packages:
  # [ qtqr, zsh-lovers, deezer, gogh-git, jetbrains-toolbox, laptop-mode-tools, modprobed-db, plymouth-themes ]
}