{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    delta = {
      enable = true;
      options = {
        syntax-theme = "Visual Studio Dark+";
        line-numbers = true;
        side-by-side = false; # needs too much space
        navigate = true; # use n and N to move between diff sections
        keep-plus-minus-markers = false;
        true-color = "always";

        hyperlinks = true;
        hyperlinks-file-link-format = "vscode://file/{path}:{line}";
        # TODO https://github.com/dandavison/open-in-editor
        #"vim://file/{path}:{line}"; # :{column} vim supports this, but it isn't implemented in delta
      };
    };

    # GitHub CLI
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    git = {
      enable = true;
      lfs.enable = true;

      signing.signByDefault = true;
      includes = [
        {
          # If the pattern ends with /, ** will be automatically added
          condition = "gitdir:~/devel/uni/";
          contents = {
            user = {
              name = "Jannik Becker";
              email = "st177878@stud.uni-stuttgart.de";
            };
            commit.gpgSign = false;
            tag.gpgSign = false;
          };
        }
        {
          condition = "gitdir:~/devel/work/";
          contents = {
            commit.gpgSign = false;
            tag.gpgSign = false;
          };
        }
      ];

      settings = {
        user = {
          name = "becknik";
          email =
            with pkgs.lib;
            d pkgs (c [
              "YmVj"
              "a25p"
              "a0Bw"
              "bS5t"
              "ZQ"
            ]);
        };

        # setting this for local config
        include.path = lib.mkAfter "${config.home.homeDirectory}/.gitconfig";

        remote.pushDefault = "origin";
        init.defaultBranch = "main";
        core = {
          filemode = false; # ignores file permission changes
          autocrlf = "input"; # CRLF -> LF; use true for LF -> CRLF -> LF (interesting for Windows)
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
          default = "current";
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
          tool = "codium";
          conflictstyle = "zdiff3";
        };
        mergetool."codium".cmd = "${pkgs.unstable.vscodium}/bin/codium --wait $MERGED";

        url."git@github.com:".insteadOf = "https://github.com/";

        status.submoduleSummary = true;
        diff.submodule = "log";

        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckObjects = true;
      };

      ignores = [
        ".idea"
        ".vscode"
        ".DS_Store"
        "node_modules"
        "target"
        "build"
        "out"
        "dist"
        "bin"
        "logs"
        "log"
        "tmp"
      ];
    };
  };

  home.file."gitconfig.example" = {
    target = ".gitconfig.example";
    text = ''
      ; [includeIf "gitdir:~/devel/.../"]
      [commit]
        gpgSign = false
      [tag]
        gpgSign = false
    '';
  };
}
