{ devenv, isDarwinSystem, pkgs, ... }:

{
  programs = {
    btop = {
      enable = true;
      settings = {
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
    bat = {
      enable = true;
      config = {
        # theme = "Visual Studio Dark+";
        style = "changes"; # numbers,
      };
    };
    broot = {
      enable = true;
      settings = {
        modal = true; # vim mode
      };
    };
    ripgrep = {
      enable = true;
    };

    ## Nix specific
    nix-index = {
      enable = true;
      # TODO the nix-index-database conflict for package derivations that differ from cache.nixos.org
    };
  };

  # Manual Installations
  home.packages =
    let makeWhenNotDarwin = pkg: (if isDarwinSystem then pkgs.hello else pkg);
    in with pkgs; [

      ## Utils
      curl
      unzip
      zip
      tree
      (makeWhenNotDarwin wl-clipboard)

      # https://github.com/ibraheemdev/modern-unix
      # including tools from some open issues, repo's unmaintained
      fd # finde for humans
      sd # sed for humans
      silver-searcher # `ag`: fast code searching tool to replace ack
      choose # unifies cut with some aspects of awk
      cheat
      tealdeer # tldr in rust
      hyperfine # benchmarking
      gping # ping with plots
      procs
      dogdns # dig alternative
      grex # regex generator
      asciinema
      tailspin # log file highlighter
      fastgron # make JSON greppable!
      tokei # loc counter

      ### Hardware
      cpufetch
      (makeWhenNotDarwin gparted)
      (makeWhenNotDarwin ventoy-full)
      (makeWhenNotDarwin powertop)
      (makeWhenNotDarwin vial)

      ## Nix(OS)
      nh
      nix-output-monitor

      nvd
      nix-diff
      nix-tree

      nix-update
      nixpkgs-review

      comma
      # devenv.packages."${pkgs.system}".devenv # commented out due to https://github.com/cachix/devenv/issues/1200

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
      (makeWhenNotDarwin valgrind)
      (makeWhenNotDarwin sysstat)

      ## Uni & TeX
      (makeWhenNotDarwin pandoc)
      (makeWhenNotDarwin gnuplot)
      (makeWhenNotDarwin qtikz)
      marp-cli
      plantuml

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
  # [ mypy perf postgresql ]
}
