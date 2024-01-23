{ ohmyzsh, flakeLock, config, pkgs, ... }:

{
  programs = {
    # zsh & bash integration are enabled by default
    hstr.enable = true; # Whether to enable Bash And Zsh shell history suggest box
    fzf.enable = true;

    bash = {
      enable = true;
      #enableVteIntegration = true; # implied by gnome
    };

    zsh = {
      enable = true;

      #dotDir = "~/.config/zsh"; # Where zsh config files are placed; randomly creates new folders in $HOME or elsewhere
      envExtra =
        "export KEYTIMEOUT=5" # Esc key in vi mode is 0.4s by default, this sets it to 0.05s
      ;

      enableAutosuggestions = true;
      #enableVteIntegration = true; # implied by gnome

      syntaxHighlighting.enable = true;
      /*zsh-abbr = { # TODO zsh-abbr isn't working...
        enable = true;
        abbreviations = { # Alias which expansion after entering, like the ones in fish
          nrbs = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#dnix\" switch";
          nrbt = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#dnix\" test";
        };
      };*/

      historySubstringSearch.enable = true;
      autocd = true; # Automatically cds into a path entered = setopt autocd

      history = {
        extended = true; # Write the history file in the ":start:elapsed;command" format
        ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate
        ignoreDups = true; # Don't record an entry that was just recorded again
        #path = "${config.programs.zsh.dotDir}/.zhistroy";
        save = 10000; # Amount of lines to save
        share = true; # Share history between all sessions.
        ignorePatterns = [ "alias" "cd" "gcsm" "gcmsg" "ls" "la" ]; # TODO this doesn't work...
        ignoreSpace = true; # Share history between all sessions.
      };

      localVariables = {
        # variable definitions on top of .zshrc
        # Further oh-my-zsh Settings
        DISABLE_AUTO_TITLE = true; # automatic setting of terminal title
        ENABLE_CORRECTION = false; # command auto corrections
        COMPLETION_WAITING_DOTS = true;
      };

      initExtraFirst = "cbonsai --multiplier 5 -m 'It takes strength to resist the dark side. Only the weak embrace it.' -p"; # Placed on top of .zshrc
      #initExtraBeforeCompInit = '''';

      initExtra =
        # further history setup
        "setopt HIST_EXPIRE_DUPS_FIRST\n" # Expire duplicate entries first when trimming history.
        + "setopt HIST_FIND_NO_DUPS\n" # Do not display a line previously found.

        + "bindkey -v\n" # vim keybindings
        + "bindkey '^H' backward-kill-word\n" # Enables Ctrl + Del to delete a full word
        # vi-style navigation in menu completion
        + "bindkey -M menuselect 'h' vi-backward-char\n"
        + "bindkey -M menuselect 'k' vi-up-line-or-history\n"
        + "bindkey -M menuselect 'l' vi-forward-char\n"
        + "bindkey -M menuselect 'j' vi-down-line-or-history\n"
        # vi-style history navigation
        + "bindkey '^k' up-history\n"
        + "bindkey '^j' down-history\n"
        # bash-like history search
        + "bindkey '^r' history-incremental-search-backward\n"
        # enable bash-like feature i cant explain rn...
        + "unsetopt flow_control\n"
        + "bindkey '^q' push-line\n"
        # auto-complete with Ctrl + Space
        + "bindkey '^ ' autosuggest-accept\n"

        # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-escape-magic
        + "autoload -Uz git-escape-magic\n"
        + "git-escape-magic\n"

        # oh-my-zsh git plugin extension function
        + ''
          function gwipmsg() {
              git add -A
              git rm $(git ls-files --deleted) 2> /dev/null
              local message="--wip-- [skip ci]"
              if [ -n "$1" ]; then
                  message="$message "$1""
              fi
              git commit --no-verify --no-gpg-sign -m "$message"
          }
        ''

        # pure plugin setup and initialization https://github.com/sindresorhus/pure#options
        + ''
          autoload -U promptinit; promptinit
          prompt pure
        ''
      ;

      oh-my-zsh = {
        enable = true;
        package =
          let
            ohmyzsh-source-locked-rev = flakeLock.nodes.ohmyzsh.locked.rev;
            # Not working:
            /* lib.readFile ("${pkgs.runCommand "convertToDate"
              { env.when = ohmyzsh-source-last-modified; }
              "date -d ${ohmyzsh-source-last-modified} +%Y-%m-%d > $out"}"); */
          in
          pkgs.oh-my-zsh.overrideAttrs (oldAttrs: {
            version = ohmyzsh-source-locked-rev;
            src = ohmyzsh;
          });
        theme = ""; # requirement for pure theme to work
        plugins = [
          "systemd"
          #"timer" # handled by pure zsh prompt theme
          "common-aliases"
          "bgnotify"
          "copyfile"
          "copypath"
          "dirhistory" # move with alt+up/down/etc
          "alias-finder"
          #"catimg"
          #"chucknorris"
          #"aws"
          "docker"
          "podman"
          "fzf"
          "git"
          "git-auto-fetch"
          "git-escape-magic"
          "gitignore"
          #"rust"
          #"mvn"
          #"pyenv"
          #"python"
          #"gradle"
          #"hitchhiker"
          #"httpie"
          "jsontools"
          #"kubectl"
          #"nmap"
          #"npm"
          #"microk8s"
          #"man"
          #"encode64"
          #"extract"
          "fancy-ctrl-z"
          #"rand-quote"
          "ripgrep"
          #"ruby"
          #"rsync"
          #"scala"
          "singlechar"
          #"ssh-agent"
          #"thefuck" # should conflict with the Esc^2 from sudo plugin
          #"transfer" # file sharing, but idk if useful for me...
          #"urltools"
          "vscode"
          "wd"
          #"web-search"
          #"zbell" # bgnotify is enough
          "zsh-interactive-cd"
          "direnv"
        ];
        # oh-my-zsh extra settings for plugins
        # $1=exit_status, $2=command, $3=elapsed_time
        extraConfig = ''
          bgnotify_bell=false;
          bgnotify_threshold=120;

          function bgnotify_formatted {
            [ $1 -eq 0 ] && title="Holy Smokes, Batman!" || title="Holy Graf Zeppelin!"
            bgnotify "$title -- after $3 s" "$2";
          }
        '' +
        # oh-my-zsh extra settings for themes:
        ''
          PURE_GIT_UNTRACKED_DIRTY=0
          zstyle :prompt:pure:git:stash show yes
        ''
        ;
      };

      shellAliases = {
        # General
        fu = "sudo";
        sduo = "sudo";

        # Flake NixOS configuration equals hostname of machine
        # `--impure` is due to flake.lock being referenced to determine version-tag of flake-input `programs.zsh.oh-my-zsh.package`
        nrbt = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#$NIXOS_CONFIGURATION_NAME\" test --impure";
        nrbs = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#$NIXOS_CONFIGURATION_NAME\" switch --impure";
        nrbb = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#$NIXOS_CONFIGURATION_NAME\" boot --impure";

        ngc = "sudo nix-collect-garbage";
        ngckeep = "sudo nix-collect-garbage --delete-older-than";
        ngcd = "sudo nix-collect-garbage -d";
        ngcdu = "nix-collect-garbage -d";

        # Git
        gai = "git add --interactive";
        grsst = "git restore --staged"; # = grst
        "gaucn!" = "gau && gcn!";
      };

      #completionInit # "Oh-My-Zsh/Prezto calls compinit during initialization, calling it twice causes slight start up slowdown"
      #defaultKeymap = "viins"; # viins vicmd # ??
    };
  };

  home.packages = with pkgs; [
    libnotify # For bg-notify zsh plugin
    (pure-prompt.overrideAttrs (oldAttrs: {
      patches = [ ./shell/no-newline.patch ];
    }))
    zsh-you-should-use # TODO include this
  ];
}
