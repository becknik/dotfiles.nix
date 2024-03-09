{ config, mkFlakeDir, userName, pkgs, ... }:

{
  programs = {
    # zsh & bash integration are enabled by default
    fzf.enable = true;

    bash = {
      enable = true;
      #enableVteIntegration = true; # implied by gnome
    };

    zsh = {
      enable = true;
      #enableVteIntegration = true; # implied by gnome
      #defaultKeymap = "viins"; # viins vicmd # ??

      envExtra = # Added to .zshenv
        "export KEYTIMEOUT=5" # Esc key in vi mode is 0.4s by default, this sets it to 0.05s
      ;

      history = {
        extended = true; # Write timestamps ":start:elapsed;command"
        ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate
        ignoreDups = true; # Don't record an entry that was just recorded again
        ignorePatterns = [ "alias *" "cd *" ]; # "gcsm *" "gcmsg *" "ls *" "la *"
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
          keybindingsVi = ''
            bindkey -v
            # Enables Ctrl + Del to delete a full word
            bindkey '^H' backward-kill-word

            # VI-style Navigation in Menu Completion
            zstyle ':completion:*' menu select
            bindkey -M menuselect 'h' vi-backward-char
            bindkey -M menuselect 'k' vi-up-line-or-history
            bindkey -M menuselect 'l' vi-forward-char
            bindkey -M menuselect 'j' vi-down-line-or-history

            # VI-style History Navigation
            bindkey '^k' up-history
            bindkey '^j' down-history
          '';
          keybindingsBash = ''
            # Enable Bash-like Feature I can't explain...
            unsetopt flow_control
            bindkey '^q' push-line
          '';
          keybindingsCustom = ''
            # Auto-Complete with Ctrl + Space
            bindkey '^ ' autosuggest-accept
          '';
          setupPlugins = ''
            # you-should-use
            YSU_MESSAGE_POSITION="after"

            # Pure Prompt
            autoload -U promptinit; promptinit
            prompt pure
            ## Pure Prompt Setup
            #PROMPT='%F{white}%* '$PROMPT # TODO add timestamp to pure prompt
            PURE_GIT_UNTRACKED_DIRTY=0
            zstyle :prompt:pure:git:stash show yes
          '';
        in

        ## History Setup (Continued)
        "setopt HIST_EXPIRE_DUPS_FIRST\n" # Expire duplicate entries first when trimming history.

        + keybindingsVi
        + keybindingsBash
        + keybindingsCustom
        + setupPlugins
      ;

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

          ## Linux
          "systemd"

          ## Development
          "docker"
          "encode64"
          "git"
          "git-auto-fetch"
          "gitignore"
          "gradle"
          "jsontools"
          "podman"
          "urltools"
          "vscode"
        ];
        #"rust" "mvn" "pyenv" "python" "aws" "kubectl" "nmap" "npm" "microk8s" "ruby" "scala"
        #"httpie" "extract" "rsync" "fancy-ctrl-z" "ripgrep" "fzf"

        ## ohmyzsh Plugin Settings
        extraConfig = ''
          bgnotify_bell=false;
          bgnotify_threshold=120;

          # ohmyzsh Git Plugin Extension Function
          function gwipmsg() {
            git add -A
            git rm $(git ls-files --deleted) 2> /dev/null
            local message="--wip-- [skip ci]"
            if [ -n "$1" ]; then
              message="$message "$1""
            fi
            git commit --no-verify --no-gpg-sign -m "$message"
          }

          # Fix for `cp: cannot create regular file '/home/jnnk/.cache/oh-my-zsh/completions/_docker': Permission denied`
          chmod u+w $HOME/.cache/oh-my-zsh/completions/_docker
        '';
      };

      localVariables = {
        # Variable definitions from top of ohmyzsh-generated .zshrc
        DISABLE_AUTO_TITLE = true; # automatic setting of terminal title
        ENABLE_CORRECTION = false; # command auto corrections
        COMPLETION_WAITING_DOTS = true;
      };

      # Plugins

      plugins =
        let
          zshPathPlugin = (zshPluginName: "share/zsh/plugins/${zshPluginName}/${zshPluginName}.plugin.zsh");
          zshPathSiteFunction = (zshPluginName: "share/zsh/site-functions/${zshPluginName}.plugin.zsh");
        in
        [
          rec {
            name = "you-should-use";
            src = pkgs.zsh-you-should-use;
            file = zshPathPlugin name;
          }
          rec {
            name = "fast-syntax-highlighting";
            src = pkgs.zsh-fast-syntax-highlighting;
            file = zshPathSiteFunction name;
          }
        ];

      historySubstringSearch.enable = true;
      enableAutosuggestions = true;
      autocd = true; # Automatically cds into a path entered; = setopt autocd
      syntaxHighlighting.enable = false;

      # Aliases

      shellAliases =
        let
        # no-link: Do not create symlinks to the build results.
          mkNomFlakeBuildCmd = "nom build --quiet --no-link \"${(mkFlakeDir userName config)}#nixosConfigurations"
            + ".$NIXOS_CONFIGURATION_NAME.config.system.build.toplevel\"";
          mkRebuildCmd = isDarwin: argument: "sudo ${if isDarwin then "darwin" else "nixos"}-rebuild "
            + "--flake \"${(mkFlakeDir userName config)}#$NIXOS_CONFIGURATION_NAME\" ${argument}";
          mkBetterRebuildCmd = isDarwin: argument: "${mkNomFlakeBuildCmd} && ${mkRebuildCmd isDarwin argument} || exit 1";
        in
        {
          # General
          fu = "sudo";
          sduo = "sudo";

          # Flake NixOS configuration equals hostname of machine
          # TODO this is ugly
          nrbs = (mkBetterRebuildCmd false "switch");
          nrbb = (mkBetterRebuildCmd false "boot");
          nrbt = (mkBetterRebuildCmd false "test");
          nrbsnn = (mkRebuildCmd false "switch");
          nrbbnn = (mkRebuildCmd false "boot");
          nrbtnn = (mkRebuildCmd false "test");

          drbs = (mkBetterRebuildCmd true "switch");
          drbb = (mkBetterRebuildCmd true "build");
          drbc = (mkBetterRebuildCmd true "check");
          drbsnn = (mkRebuildCmd true "switch");
          drbbnn = (mkRebuildCmd true "build");
          drbcnn = (mkRebuildCmd true "check");

          ngc = "sudo nix-collect-garbage";
          ngckeep = "sudo nix-collect-garbage --delete-older-than";
          ngcd = "sudo nix-collect-garbage -d";
          ngcdu = "nix-collect-garbage -d";

          # Git
          gai = "git add --interactive";
          grsst = "git restore --staged"; # = grst
          grhp = "git reset -p"; # useful for unstaging staged hunks

          ## Frankensteins
          "gaucn!" = "gau && gcn!";
          gcnpf = "gcn! && gpf";
          gaucnpf = "gau && gcn! && gpf";
        };
    };
  };

  home.packages = with pkgs; [
    libnotify # For bg-notify zsh plugin
    (pure-prompt.overrideAttrs (oldAttrs: {
      patches = [ ./shell/zsh-pure-prompt.patch ];
    }))
  ];
}
