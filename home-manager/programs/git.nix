{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    ## Diff syntax highlighting tools
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

    userName = "becknik";
    userEmail =
      with pkgs.lib;
      d pkgs (c [
        "YmVj"
        "a25p"
        "a0Bw"
        "bS5t"
        "ZQ"
      ]);
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

    extraConfig = {
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

  home.file."gitconfig-disable-signing" = {
    target = ".gitconfig-disable-signing";
    text = ''
      ; [includeIf "gitdir:~/devel/.../"]
      [commit]
        gpgSign = false
      [tag]
        gpgSign = false
    '';
  };
}
