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

    ### Hardware
    cpufetch
    gparted
    ventoy
    powertop

    ## NixOS
    nixos-option
    # https://github.com/nix-community/nixd
    unstable.nixd # TODO Figure out how to set up nixd - Seems like this isn't possible at all so far... https://github.com/nix-community/vscode-nix-ide/issues/363
    unstable.nil
    nixpkgs-fmt
    nixpkgs-lint

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
    anki
    marp-cli

    ## TeX Live

    # Source for new 23.11 interface: https://github.com/NixOS/nixpkgs/issues/250243
    (texlive.withPackages (ps: with ps; [
      scheme-medium # Need xelatex which is included right here
      # I'm really annoyed by manually listing every packages I need below and this solves it

      ### General Purpose
      biblatex biber
      mmap enumitem pgfplots

      ### Formatting

      changepage #### Page Layout

      csquotes #### Text

      lipsum ### Nice-to-Haves

     fifo-stack varwidth tabto-ltx totcount tikzmark ### Dependency of algpseudocodex

      pdfcolmk ### ???
    ] ))

    ## Trash
    neofetch
    cmatrix
    fortune
    sl
    cbonsai
    oneko
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