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

      envExtra = # Added to .zshenv
        ''
          # Esc key in vi mode is 0.4s by default, this sets it to 0.05s
          export KEYTIMEOUT=5

          # fzf vim binding with ctrl/alt
          export FZF_DEFAULT_OPTS="--bind 'ctrl-j:down,ctrl-k:up,alt-j:preview-down,alt-k:preview-up'"

          # https://github.com/wfxr/forgit/tree/master?tab=readme-ov-file#--keybinds
          # gds with staged would be nice
          export FORGIT_COPY_CMD='${pkgs.wl-clipboard}/bin/wl-copy'
          export forgit_add=fga
          export forgit_blame=fgbl
          export forgit_branch_delete=fgbd
          #gcb
          export forgit_checkout_branch=fgcob
          export forgit_checkout_commit=fgco
          #gcf
          export forgit_checkout_file=fgcof
          #gct
          export forgit_checkout_tag=fgcot
          export forgit_cherry_pick=fgcp
          export forgit_clean=fgclean
          export forgit_diff=fgd
          export forgit_fixup=fgfu
          export forgit_ignore=fgi
          export forgit_log=fglo
          #grb
          export forgit_rebase=fgrbi
          #grh TODO How to disable forgit aliases?
          export forgit_reset_head='git forgit reset_head'
          export forgit_revert_commit=fgrev
          #gsp
          export forgit_stash_push=fgsta
          #gss
          export forgit_stash_show=fgstl
        ''
      ;
      # Further alias declared below!

      history = {
        extended = true; # Write timestamps ":start:elapsed;command"
        ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate
        ignoreDups = true; # Don't record an entry that was just recorded again
        ignorePatterns = [ "alias *" "cd *" "nix/store/*" ]; # "gcsm *" "gcmsg *" "ls *" "la *"
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
          '';
          # # VI-style History Navigation
          # bindkey '^k' up-history
          # bindkey '^j' down-history
          keybindingsBash = ''
            # Enable Bash-like Feature I can't explain...
            unsetopt flow_control
            bindkey '^q' push-line
          '';
          keybindingsCustom = ''
            # Auto-Complete with Ctrl + Space
            bindkey '^ ' autosuggest-accept
          '';

          # at least syntax-highlighting must be placed after compinit, I think
          pluginSource = with pkgs; ''
            source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
            source ${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
            source ${fzf-git-sh-patched}/share/fzf-git-sh/fzf-git.sh
            source ${zsh-forgit-patched}/share/zsh/zsh-forgit/forgit.plugin.zsh
          '';
          pluginSetup = ''
            # you-should-use
            YSU_MESSAGE_POSITION="after"

            # Pure Prompt
            autoload -U promptinit; promptinit
            prompt pure
            ## Pure Prompt Setup
            #PROMPT='%F{white}%* '$PROMPT # TODO add timestamp to pure prompt
            PURE_GIT_UNTRACKED_DIRTY=254
            zstyle :prompt:pure:git:stash show yes

            # prepend datetime to pure prompt
            # https://github.com/sindresorhus/pure/issues/667
            eval "original_$(declare -f prompt_pure_preprompt_render)"
            prompt_pure_preprompt_render() {
              local prompt_pure_date_color='250'
              local prompt_pure_date_format="[%H:%M:%S]"
              local prompt_pure_date=$(date "+$prompt_pure_date_format")
              original_prompt_pure_preprompt_render
              PROMPT="%F{$prompt_pure_date_color}''${prompt_pure_date}%f $PROMPT"
            }

            # fzf-git.sh
            bindkey -r "^G" # unbinds `bindkey -r "^G"`
            _fzf_git_fzf() {
              fzf-tmux -p80%,60% -- \
                --multi --cycle --reverse --height=80% --min-height=20 --border \
                --border-label-pos=2 \
                --color='header:italic,label:blue' \
                --preview-window='right,40%,border-left' \
                --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
            }

            # yazi shortcut
            function yy() {
              local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
              yazi "$@" --cwd-file="$tmp"
              if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                cd -- "$cwd"
              fi
              rm -f -- "$tmp"
            }
          '';

          scriptsCustom = ''
            rerun-previous-command-if-empty() {
              if [[ -z $BUFFER ]]; then
                zle up-history
                zle accept-line
              else
                zle .accept-line
              fi
            }
            zle -N accept-line rerun-previous-command-if-empty
          '';
        in
        keybindingsVi
        + keybindingsBash
        + keybindingsCustom
        + pluginSource
        + pluginSetup
        + scriptsCustom
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
            + "--flake \"${(mkFlakeDir userName config)}#$NIXOS_CONFIGURATION_NAME\" ${argument}";

          mkRebuildCmdNh = argument: "nh os ${argument} ${(mkFlakeDir userName config)} --hostname $NIXOS_CONFIGURATION_NAME";
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
    pure-prompt-patched
    libnotify # For bg-notify zsh plugin
    zsh-forgit-patched
  ];
}
