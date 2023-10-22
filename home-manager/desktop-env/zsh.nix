{ config, ... }:

{
  programs = {
    hstr.enable = true;
    zsh = {
      enable = true;

      enableAutosuggestions = true;
      enableVteIntegration = true;

      autocd = true; # Autoamatically cds into a path enterd; setopt autocd
      #completionInit = "autoload -Uz compinit promptinit && compinit && promptinit"; #zmodload zsh/complist
      #zstyle :compinstall filename '/home/jnnk/.zshrc'
      #defaultKeymap = "viins"; # viins vicmd # TODO What's that?!

      dirHashes = {
        dl = "${config.home.homeDirectory}/dl";
        docs = "${config.home.homeDirectory}/docs";
        devel = "${config.home.homeDirectory}/devel";
      };
      dotDir = ".config/zsh"; # Where zsh config files are placed
      envExtra =
        "export KEYTIMEOUT=5" # Esc key in vi mode is 0.4s by default, this sets it to 0.05s
      ;

      history = {
        extended = false; # Write the history file in the ":start:elapsed;command" format
        #ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate # TODO not yet available
        ignoreDups = true; # Don't record an entry that was just recorded again
        ignorePatterns = [ "git" "gcl" "alias" ];
        ignoreSpace = true; # Share history between all sessions.
        path = "${config.programs.zsh.dotDir}/.zhistroy";
        save = 10000; # Amount of lines to save
        share = true; # Share history between all sessions.
      };
      historySubstringSearch.enable = true;

      localVariables = { # variable definitions on top of .zshrc
        # Further oh-my-zsh Settings
        DISABLE_AUTO_TITLE = true; # automatic setting of terminal title
        ENABLE_CORRECTION = false; # command auto corrections
        COMPLETION_WAITING_DOTS = true;
      };

      #initExtraFirst = ""; # Placed on top of .zshrc
      #initExtraBeforeCompInit = '''';
      initExtra =
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
        #https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-escape-magic
        + "autoload -Uz git-escape-magic"
        #+ "cbonsai --multiplier 5 -m 'It takes strength to resist the dark side. Only the weak embrace it.' -p"
      ;

      oh-my-zsh = {
        enable = true;
        theme = "bullet-train"; # TODO This repo (is) should be synced via program.git.repositories in the devel.nix file
        custom = "${config.programs.zsh.dotDir}/oh-my-zsh/custom";
        extraConfig =  # oh-my-zsh extra settings for plugins
# $1=exit_status, $2=command, $3=elapsed_time
''function bgnotify_formatted {
  [ $1 -eq 0 ] && title="Holy Smokes, Batman!" || title="Holy Graf Zeppelin!"
  bgnotify "$title -- after $3 s" "$2";
}
bgnotify_threshold=10;
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
BULLETTRAIN_PROMPT_SEPARATE_LINE=false
#BULLETTRAIN_GIT_COLORIZE_DIRTY=true
''
        ;
        plugins = [
          #"archlinux"
          #"sudo"
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
          "aws"
          "docker"
          #"fzf"
          #"fzf-tab"
          "git"
          "git-auto-fetch"
          "git-escape-magic"
          "gitignore"
          "rust"
          "mvn"
          #"pyenv"
          "python"
          "gradle"
          #"hitchhiker"
          "httpie"
          "jsontools"
          "kubectl"
          "nmap"
          "npm"
          "microk8s"
          #"man"
          "encode64"
          #"extract"
          "fancy-ctrl-z"
          #"rand-quote"
          "ripgrep"
          "ruby"
          "rsync"
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
      };
      shellAliases = {
        fu = "sudo";
        sduo = "sudo";
        #code = "vscodium"; # TODO Doesn't work
      };

      #syntaxHighlighting.enable = true; # TODO Not available & the current one is crappy af :|
      /*zsh-abbr = { # TODO Not available
        enable = true;
        abbreviations = {}; # Alias which expansion after entering, like the ones in fish
      };*/
    };
  };
}

#setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
# Starts separate vim editor when pressing Esc instead of edit command with vim-bindings in shell
#autoload -U edit-command-line
#zle -N edit-command-line
#bindkey -M vicmd v edit-command-line
#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
#[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white,bold,underline"
# ssh key evaluation for GNOME keychain - now done via oh-my-zsh plugin
#eval $(keychain --eval --quiet git-personal)
#zstyle ':completion:*' menu select
#zstyle ':completion::complete:*' gain-privileges 1
## source: https://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc
#zstyle ':completion:*:*:pacman:*' menu yes select

## Alias stuff
#alias ls="ls --color -F"
#alias ll="ls --color -lh"
#alias cp='cp -iv --reflink=auto'
#alias rcp='rsync -v --progress'
#alias rmv='rsync -v --progress --remove-source-files'
#alias mv='mv -iv'
#alias rm='rm -iv'
#alias rmdir='rmdir -v'
#alias ln='ln -v'
#alias chmod="chmod -c"
#alias chown="chown -c"
#alias mkdir="mkdir -v"
#alias grep='grep --colour=auto'
#alias egrep='egrep --colour=auto'
#alias ls='ls --color=auto --human-readable --group-directories-first --classify'
#alias ll='ls --color=auto --human-readable --group-directories-first --classify -l'
#alias lla='ls --color=auto --human-readable --group-directories-first --classify -la'
# Own:
#alias fu='sudo'
#alias sduo='sudo'
#alias cat='bat'
#alias catt="cat"
#alias paru="paru --bottomup --removemake"
#alias upd="paru -Syu --bottomup --removemake --upgrademenu --devel --cleanafter --combinedupgrade --sudoloop"
