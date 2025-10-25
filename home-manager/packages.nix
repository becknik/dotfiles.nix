{
  pkgs,
  ...
}:

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
    let
      mkWhenNotDarwin = pkg: (if pkgs.stdenv.isDarwin then pkgs.hello else pkg);
    in
    with pkgs;
    [

      ## Utils
      curl
      unzip
      zip
      tree
      (mkWhenNotDarwin wl-clipboard)

      # https://github.com/ibraheemdev/modern-unix
      # including tools from some open issues, repo's unmaintained
      fd # find for humans
      sd # set for humans
      silver-searcher # `ag`: fast code searching tool to replace ack
      choose # unifies cut with some aspects of awk
      cheat
      tealdeer # tldr in rust
      hyperfine # benchmarking
      asciinema
      tailspin # log file highlighter
      fastgron # make JSON greppable!
      tokei # loc counter
      mmv

      ### Hardware
      cpufetch
      (mkWhenNotDarwin gparted)
      (mkWhenNotDarwin powertop)
      (mkWhenNotDarwin vial)

      ## Nix(OS)
      nh
      nix-output-monitor
      (nix-tree.overrideAttrs (oldAttrs: {
        version = "0.6.3";
        src = pkgs.fetchFromGitHub {
          owner = "utdemir";
          repo = "nix-tree";
          rev = "v0.6.3";
          sha256 = "sha256-579p1uqhICfsBl1QntcgyQwTNtbiho1cuNLDjjXQ+sM=";
        };
      }))

      nix-update
      nixpkgs-review
      comma

      ### Secrets Management (1)
      sops
      age
      age-plugin-yubikey
      (mkWhenNotDarwin yubioath-flutter)
      (mkWhenNotDarwin yubikey-personalization-gui)
      tig

      ## Benchmarking
      speedtest-cli

      ## Uni & TeX
      (mkWhenNotDarwin pandoc)
      (mkWhenNotDarwin qtikz)

      ## Trash
      cbonsai
      # cmatrix
      # fortune
      # (makeWhenNotDarwin oneko)
      # uwuify
    ];
}
