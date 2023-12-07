{ config, pkgs, ... }:

{
  programs = {
    hstr.enable = true; # Whether to enable Bash And Zsh shell history suggest box

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;

      dotDir = ".config/zsh"; # Where zsh config files are placed
      envExtra =
        "export KEYTIMEOUT=5" # Esc key in vi mode is 0.4s by default, this sets it to 0.05s
      ;

      enableAutosuggestions = true;
      enableVteIntegration = true;

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
        path = "${config.programs.zsh.dotDir}/.zhistroy";
        save = 10000; # Amount of lines to save
        share = true; # Share history between all sessions.
        ignorePatterns = [ "alias" "cd" "gcsm" "ls" "la" ];
        ignoreSpace = true; # Share history between all sessions.
      };

      localVariables = {
        # variable definitions on top of .zshrc
        # Further oh-my-zsh Settings
        DISABLE_AUTO_TITLE = true; # automatic setting of terminal title
        ENABLE_CORRECTION = false; # command auto corrections
        COMPLETION_WAITING_DOTS = true;
      };

      #initExtraFirst = ""; # Placed on top of .zshrc
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
        # bonsai
        + "cbonsai --multiplier 5 -m 'It takes strength to resist the dark side. Only the weak embrace it.' -p"
      ;

      oh-my-zsh = {
        enable = true;
        theme = "bullet-train";
        plugins = [
          "systemd"
          #"timer"
          "common-aliases"
          "bgnotify"
          "copyfile"
          "copypath"
          #"dirhistory"
          "alias-finder"
          #"catimg"
          #"chucknorris"
          #"aws"
          "docker"
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
          #"jsontools"
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
          #"transfer" # file sharing, but idk if usefull fo rme...
          #"urltools"
          "vscode"
          "wd"
          #"web-search"
          "zbell"
          "zsh-interactive-cd"
          "direnv"
        ];
        custom = "${config.home.homeDirectory}/.config/oh-my-zsh/custom";
        extraConfig = # oh-my-zsh extra settings for plugins
          # $1=exit_status, $2=command, $3=elapsed_time
          ''bgnotify_bell=false;
bgnotify_threshold=10;

function bgnotify_formatted {
  [ $1 -eq 0 ] && title="Holy Smokes, Batman!" || title="Holy Graf Zeppelin!"
  bgnotify "$title -- after $3 s" "$2";
}

TIMER_PRECISION=2;
TIMER_FORMAT="[%d]";
TIMER_THRESHOLD=.5;
'' +
          # oh-my-zsh extra settings for themes:
          # Not set: perl nvm hg
          ''BULLETTRAIN_PROMPT_ORDER=("time" "status" "context" "custom" "dir" "ruby" "virtualenv" "aws" "go" "elixir" "git" "cmd_exec_time");
BULLETTRAIN_PROMPT_SEPARATE_LINE=true;
BULLETTRAIN_PROMPT_ADD_NEWLINE=false;
BULLETTRAIN_STATUS_EXIT_SHOW=true;
BULLETTRAIN_IS_SSH_CLIENT=true;
BULLETTRAIN_PROMPT_SEPARATE_LINE=true;
#BULLETTRAIN_GIT_COLORIZE_DIRTY=true;
''
        ;
      };
      shellAliases = {
        fu = "sudo";
        sduo = "sudo";
        nrbs = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#dnix\" switch";
        nrbt = "sudo nixos-rebuild --flake \"${config.home.homeDirectory}/devel/own/dotfiles.nix#dnix\" test";
      };

      #completionInit # "Oh-My-Zsh/Prezto calls compinit during initialization, calling it twice causes slight start up slowdown"
      #defaultKeymap = "viins"; # viins vicmd # ??
    };
  };

  home.packages = [ pkgs.libnotify ]; # For bg-notify zsh plugin
}
