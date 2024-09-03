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
      settings.modal = true; # vim mode
    };
    ripgrep.enable = true;

    ## Nix specific
    nix-index.enable = true;
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
      mmv

      ### Hardware
      cpufetch
      (makeWhenNotDarwin gparted)
      (makeWhenNotDarwin ventoy-full)
      (makeWhenNotDarwin powertop)
      (makeWhenNotDarwin vial)

      ## Nix(OS)
      nh
      nix-output-monitor
      nix-tree

      nix-update
      nixpkgs-review
      comma

      ### Secrets Management (1)
      sops
      age
      #age-plugin-yubikey # This isn't working with sops-nix atm due to sops... https://github.com/Mic92/sops-nix/issues/377
      (makeWhenNotDarwin yubikey-manager-qt)
      (makeWhenNotDarwin yubikey-personalization-gui)

      ## Benchmarking
      speedtest-cli

      ## Uni & TeX
      (makeWhenNotDarwin pandoc)
      (makeWhenNotDarwin gnuplot)
      (makeWhenNotDarwin qtikz)
      marp-cli

      ## Trash
      neofetch
      # cmatrix
      # fortune
      cbonsai
      # (makeWhenNotDarwin oneko)
      # uwuify
    ];
}
