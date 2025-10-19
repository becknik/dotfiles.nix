{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./tmux.nix
    ./aliases.nix
    ./terminal-emulators.nix
  ];

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
        ratio = [
          2
          3
          3
        ];
        sort_by = "natural";
        sort_sensitive = false;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };
    };

    zsh = {
      enable = true;
      #enableVteIntegration = true; # implied by gnome
      #defaultKeymap = "viins"; # viins vicmd # ??

      # https://zsh.sourceforge.io/Doc/Release/Options.html
      history = {
        extended = true; # Write timestamps ":start:elapsed;command"
        ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate
        size = 12000; # must be larger for `ignoreAllDups` to work
        save = 10000;
        ignoreDups = true; # Don't record an entry that was just recorded again
        # "gcsm *" "gcmsg *" "ls *" "la *"
        ignorePatterns = [
          "alias *"
          "cd *"
          "*/nix/store/*"
          "z *"
          "nvim *"
          "gcmsg *" # oh-my-zsh `git commit -m` alias
        ];
        ignoreSpace = true; # Don'd add commands to history if first character is a space
        #save = 10000; # Amount of lines to save, the default
        share = true; # Share history between all sessions.
      };

      envExtra = builtins.readFile ./files/zshenv.zsh;
      completionInit = "";
      initContent =
        let
          cbonsai = lib.mkBefore "cbonsai --life 42 -m 'It takes strength to resist the dark side. Only the weak embrace it' -p";
          extraRc = builtins.readFile ./files/zshrc.zsh;

          # at least syntax-highlighting must be placed after compinit, I think
          # source ${fzf-git-sh-patched}/share/fzf-git-sh/fzf-git.sh
          pluginSource = with pkgs; ''
            # source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
            source ${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
            source ${zsh-forgit-patched}/share/zsh/zsh-forgit/forgit.plugin.zsh
          '';
        in
        lib.mkMerge [
          cbonsai
          pluginSource
          extraRc
          # envExtra
        ];

      oh-my-zsh = {
        enable = true;
        package = pkgs.oh-my-zsh-git;
        theme = ""; # requirement for pure theme to work

        # some plugins also configured in the nixos.nix / darwin.nix profile files
        plugins = [
          ## Shell
          "alias-finder"
          "copyfile"
          "copypath"
          "dirhistory" # move with alt+up/down/etc
          "singlechar"
          # "wd" # zoxide is superior to this
          # "zsh-interactive-cd" # shadowed by fzf built-in zsh integration
          "extract"
          "tmux"

          ## Development
          "git"
          "git-auto-fetch"
          # "gitignore" # gi <nix haskell ...>
          # also provided by zsh-forit plugin with fzf search

          "docker"
          "docker-compose"
          "kubectl"

          "httpie"
          "encode64" # e64 "..."
          "jsontools"
          "urltools"
          "vscode"

          ### Programming
          "mvn"
          "gradle"
          "node"

        ];
        #"rust" "pyenv" "python" "aws" "nmap" "npm" "ruby" "scala"
        # "rsync" "fancy-ctrl-z" "ripgrep" "fzf" "zsh-interactive-cd"
        # "history-substring-search" already handled by home-manager
        # "fzf" does what is already implicitly handled by `Programs.fzf.enable = true;`
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
      autosuggestion.enable = true;
      autocd = true; # Automatically cds into a path entered; = setopt autocd
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    pure-prompt-patched
    zsh-forgit-patched
  ];
}
