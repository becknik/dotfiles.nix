{ config, mkFlakeDir, userName, pkgs, ... }:

{
  programs = {
    # zsh & bash integration are enabled by default
    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
    fzf.enable = true;
    eza = {
      enable = true;
      git = true;
    };
    zoxide.enable = true;
    yazi = {
      enable = true;
      settings.manager = {
        ratio = [ 2 3 3 ];
        sort_by = "natural";
        sort_sensitive = false;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };
      theme = {
        manager = {
          syntect_theme = "Catppuccin Mocha"; # Catppuccin Frappe
        };
      };
    };
    zellij = {
      enable = true;
      #settings = {};
    };

    bash = {
      enable = true;
      #enableVteIntegration = true; # implied by gnome
    };
    zsh = {
      enable = true;
      #enableVteIntegration = true; # implied by gnome
      #defaultKeymap = "viins"; # viins vicmd # ??

      envExtra = builtins.readFile ./files/.zshenv.extraEnv.zsh;

      history = {
        extended = true; # Write timestamps ":start:elapsed;command"
        ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate
        ignoreDups = true; # Don't record an entry that was just recorded again
        ignorePatterns = [ "alias *" "cd *" "*/nix/store/*" "z *" ]; # "gcsm *" "gcmsg *" "ls *" "la *"
        ignoreSpace = true; # Don'd add commands to history if first character is a space
        #save = 10000; # Amount of lines to save, the default
        share = true; # Share history between all sessions.
      };

      ################################################################################
      # .zshrc Setup Section
      ################################################################################

      initExtraFirst = "cbonsai --life 42 -m 'It takes strength to resist the dark side. Only the weak embrace it' -p";

      completionInit = "";

      initExtra =
        let
          # at least syntax-highlighting must be placed after compinit, I think
          pluginSource = with pkgs; ''
            source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
            source ${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
            source ${fzf-git-sh-patched}/share/fzf-git-sh/fzf-git.sh
            source ${zsh-forgit-patched}/share/zsh/zsh-forgit/forgit.plugin.zsh
          '';
        in
        pluginSource + builtins.readFile ./files/.zshrc.initExtra.zsh;

      oh-my-zsh = {
        enable = true;
        package = pkgs.oh-my-zsh-git;
        theme = ""; # requirement for pure theme to work

        plugins = [
          ## Shell
          "alias-finder"
          "bgnotify"
          "common-aliases"
          "copyfile"
          "copypath"
          "direnv"
          "dirhistory" # move with alt+up/down/etc
          "singlechar"
          "wd"
          "zsh-interactive-cd"
          "extract"

          ## Linux
          "systemd"

          ## Development
          "git"
          "git-auto-fetch"
          "gitignore"

          "podman"
          "docker"
          "kubectl"

          "mvn"
          "gradle"

          "encode64"
          "jsontools"
          "urltools"
          "vscode"
        ];
        #"rust" "pyenv" "python" "aws" "nmap" "npm" "ruby" "scala"
        #"httpie" "rsync" "fancy-ctrl-z" "ripgrep" "fzf"
        # "history-substring-search" already handled by home-manager
        # "fzf" does what is already implicitly handled by `Programs.fzf.enable = true;`

        ## ohmyzsh Plugin Settings (located at top of the generated .zshrc)
        extraConfig = builtins.readFile ./files/.zshrc.extraConfig.zsh;
      };

      localVariables = {
        # Variable definitions from top of ohmyzsh-generated .zshrc
        DISABLE_AUTO_TITLE = true; # automatic setting of terminal title
        ENABLE_CORRECTION = false; # command auto corrections
        COMPLETION_WAITING_DOTS = true;
        # zoxide setup (variables must be declared before sourcing zoxide)
        _ZO_EXCLUDE_DIRS = "/nix";
      };

      # Plugins

      #historySubstringSearch.enable = true; # TODO is this shadowed by fzf?
      enableAutosuggestions = true;
      autocd = true; # Automatically cds into a path entered; = setopt autocd
      syntaxHighlighting.enable = false;

      # Aliases

      shellAliases =
        let
          mkRebuildCmd = isDarwin: argument:
            "${if isDarwin then "darwin" else "sudo nixos"}-rebuild "
            + "--flake \"${(mkFlakeDir userName config)}#$FLAKE_NIXOS_HOST\" ${argument}";

          mkRebuildCmdNh = argument: "nh os ${argument} ${(mkFlakeDir userName config)} --hostname $FLAKE_NIXOS_HOST";
        in
        {
          # Flake NixOS configuration equals hostname of machine
          # TODO this is ugly
          nrbs = (mkRebuildCmd false "switch");
          nrbb = (mkRebuildCmd false "boot");
          nrbt = (mkRebuildCmd false "test");

          nhs = (mkRebuildCmdNh "switch");
          nht = (mkRebuildCmdNh "boot");
          nhb = (mkRebuildCmdNh "test");

          # drbs = (mkBetterRebuildCmd true "switch");
          # drbb = (mkBetterRebuildCmd true "build");
          # drbc = (mkBetterRebuildCmd true "check");
          # FIXME git+file:///Users/jbecker/devel/own/dotfiles.nix' does not provide attribute 'packages.x86_64-darwin.nixosConfigurations.wnix.config.system.build.toplevel',
          # 'legacyPackages.x86_64-darwin.nixosConfigurations.wnix.config.system.build.toplevel' or 'nixosConfigurations.wnix.config.system.build.toplevel'

          drbs = (mkRebuildCmd true "switch");
          drbb = (mkRebuildCmd true "build");
          drbc = (mkRebuildCmd true "check");

          ngc = "sudo nix-collect-garbage";
          ngckeep = "sudo nix-collect-garbage --delete-older-than";
          ngcd = "sudo nix-collect-garbage -d";
          ngcdu = "nix-collect-garbage -d";

          # General
          fu = "sudo";
          sduo = "sudo";

          # Git
          gai = "git add --interactive";
          grsst = "git restore --staged"; # = grst
          grhp = "git reset -p"; # useful for unstaging staged hunks

          ## Frankensteins
          "gaucn!" = "gau && gcn!";
          gcnpf = "gcn! && gpf";
          gaucnpf = "gau && gcn! && gpf";

          # Aliases for zsh-forgit
          sgds = "sgd --staged";
        };
    };
  };

  home.packages = with pkgs; [
    libnotify # For bg-notify zsh plugin

    pure-prompt-patched
    zsh-forgit-patched
  ];
}
