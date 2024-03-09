{ system, lib, pkgs, ... }:

{
  imports = [
    ./devel/proglangs.nix # Installation of some programming languages

    ./programs/neovim.nix # Nixvim neovim configuration
    ./programs/vscodium.nix
  ];

  # git Setup
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      ## Diff syntax highlighting tools
      delta = {
        enable = true;
        options = {
          features = "decorations";
          true-color = "always";
          theme = "Monokai Extended";
          navigate = true;
          line-numbers = true;
          hyperlinks = true;
          hyperlinks-file-link-format = "vscode://file/{path}:{line}";
          interactive = {
            keep-plus-minus-markers = false;
          };
        };
      };
      /* diff-so-fancy = {
        enable = true;
        markEmptyLines = false;
      }; */
      #difftastic.enable = true; # Side-by-side diff view in terminal, looks odd to me

      ## (User) Config
      userName = "becknik";
      userEmail = "jannikb@posteo.de";
      extraConfig = {
        init.defaultBranch = "main";
        core = {
          filemode = false; # ignores file permission changes
          autocrlf = "input"; # CRLF -> LF; use true for LF -> CRLF -> LF (intersting for Windows)
        };
        log.date = "iso";
        help.autocorrect = 10; # 10 seconds to correct wrong command

        fetch = {
          #prune = true;
          pruneTags = true;
        };
        commit.verbose = true;
        diff = {
          algorithm = "histogram";
          context = 5;
          colorMoved = "default";
        };

        pull.rebase = true;
        push = {
          dafault = "current";
          autoSetupRemote = true;
          followtags = true; # push tags with commits
        };

        tag.sort = "-taggerdate";
        branch.sort = "-committerdate";
        column.ui = "auto";
        rerere.enabled = true;
        # https://andrewlock.net/working-with-stacked-branches-in-git-is-easier-with-update-refs/
        rebase.updateRefs = true;
        merge = {
          tool = "vscodium";
          conflictstyle = "zdiff3";
        };
        mergetool."vscodium".cmd = "vscodium --wait $MERGED";

        url."git@github.com:".insteadOf = "https://github.com/";

        status.submoduleSummary = true;
        diff.submodule = "log";

        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckObjects = true;
      };

      ignores = [ ".idea" ".vscode" ".DS_Store" "node_modules" "target" "build" "out" "dist" "bin" "logs" "log" "tmp" ];

      includes = [
        #{ condition = "gitdir:~/devel/work/"; content = ""; /* path = ""; */ }
      ];

      # Sources (not sure if working)
      # https://gist.github.com/ruediger/5647207
      # https://gist.github.com/tekin/12500956bd56784728e490d8cef9cb81
      attributes = [
        # TODO Enable binary diffs: https://gist.github.com/Konfekt/5ece511a94a8aa118aadbbb23dab1f21
        "*.bib diff=bibtex"
        "*.c diff=cpp"
        "*.c++ diff=cpp"
        "*.cc diff=cpp"
        "*.cpp diff=cpp"
        "*.css diff=css"
        "*.cxx diff=cpp"
        "*.ex diff=elixir"
        "*.exs diff=elixir"
        #"*.gif diff=exif"
        "*.go diff=golang"
        "*.h diff=cpp"
        "*.h++ diff=cpp"
        "*.hh diff=cpp"
        "*.hpp diff=cpp"
        "*.html diff=html"
        #"*.jpeg diff=exif"
        #"*.jpg diff=exif"
        "*.md diff=markdown"
        "*.pdf diff=pdf"
        "*.pl diff=perl"
        #"*.png diff=exif"
        "*.py diff=python"
        "*.rake diff=ruby"
        "*.rb diff=ruby"
        "*.rs diff=rust"
        "*.tex diff=tex"
        "*.xhtml diff=html"
        "*.java diff=java"
        "*.kt diff=kotlin"
        "*.sh diff=bash"
      ];
    };

    gitui.enable = true; # TODO is this worth it?

    # GitHub CLI
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # DirEnv Setup
    direnv = {
      enable = true; # nix-direnv gets enabled automatically in NixOS - but not in home-manager...
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    # SSH
    # Source: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
    ssh = {
      enable = true;
      extraConfig = "AddKeysToAgent confirm"; #addKeysToAgent = "confirm"; isn't working?
      forwardAgent = true;
      hashKnownHosts = true;
      matchBlocks = {
        github_personal = {
          host = "github.com";
          user = "git";
          identityFile = "~/.ssh/github-personal";
        };
      };
    };
  };

  # GPG-Agent
  services.gpg-agent = {
    # TODO use keychain instead of gpg-agent?
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    extraConfig = "";
    pinentryFlavor = "gnome3";
    #sshKeys = {}; # Expose GPG-keys as SSH-keys
  };
  programs. gpg. enable = true;

  # Manual Installations
  home.packages = with pkgs; [
    git-crypt
    meld
    wiggle

    # LLM (ChatGPT)
    shell_gpt

    # JetBrains IDEs
    unstable.jetbrains.clion
    unstable.jetbrains.idea-ultimate

    ## OCI Containers
    dive # https://github.com/wagoodman/dive
    trivy

    ## Build Tools
    gradle
    maven
    gnumake

    ## Testing
    httpie
    newman

    # Latest postman build fails to download - last checked 2023.12.06
    #> curl: (22) The requested URL returned error: 404
    #> error: cannot download postman-10.18.6.tar.gz from any mirror
    (import
      (builtins.fetchGit {
        name = "nixpkgs-unstable-postman-10.15.0";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-unstable";
        rev = "976fa3369d722e76f37c77493d99829540d43845";
      })
      {
        inherit system;
        config.allowUnfree = true;
      }).postman

    ### SQL
    (dbeaver.override { jdk17 = temurin-bin-17; })

    ## CI / CD
    awscli2
    kubectl
    act
  ];
}
