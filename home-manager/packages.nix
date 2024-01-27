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
  home.packages = with pkgs; [

    ## Utils
    jq
    curl
    ripgrep
    unzip
    tldr
    tree
    bat

    ### Hardware (1)
    cpufetch

    ## NixOS
    nixos-option

    ### Secrets Management (1)
    sops
    age
    #age-plugin-yubikey # This isn't working with sops-nix atm due to sops... https://github.com/Mic92/sops-nix/issues/377

    ## Penetration Testing
    nmap

    ## Benchmarking (1)
    speedtest-cli
    stress-ng
    valgrind

    ## Uni & TeX (1)
    gnuplot
    pandoc
    marp-cli

    ## Trash
    neofetch
    cmatrix
    fortune
    sl
    cbonsai
    oneko
    uwuify
    #uwufetch # TODO uwufetch seems to be broken
  ] ++
  (lib.lists.optionals (system != "x86_64-darwin")
    (with pkgs; [

      ## Utils

      ### desktop-env
      wl-clipboard

      ### Hardware (2)
      gparted
      ventoy-full
      powertop

      ## NixOS

      ### Secrets Management (2)
      yubikey-manager-qt
      yubikey-personalization-gui

      ## Benchmarking (2)
      sysstat

      ## Uni & TeX (1)
      qtikz
      anki

    ])
  )
  ;

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
