{ pkgs, ... }:

{
  programs.vscode.userSettings = {
    ## Code Runner
    code-runner = {
      clearPreviousOutput = true;
      enableAppInsights = false; # Whether to enable AppInsights to track user telemetry data.
    };

    ## Project Manager
    projectManager = {
      groupList = true;
      ignoreProjectsWithinProjects = true;
      openInNewWindowWhenClickingInStatusBar = true;
      showParentFolderInfoOnDuplicates = true;
      sortList = "Recent";
      git.baseFolders = [ "~/devel/own" "~/devel/foreign" "~/devel/ide" "~/devel/work" ];
      confirmSwitchOnActiveWindow = "onlyUsingSideBar";
    };

    ## Direnv
    direnv.restart.automatic = true;
    direnv.status.showChangesCount = true;

    ## Path Intellisense
    path-intellisense = {
      autoTriggerNextSuggestion = true;
      extensionOnImport = true;
      showHiddenFiles = true;
    };

    ## cSpell
    cSpell = {
      enabled = true;
      caseSensitive = true;
      #enableCompoundWords = true;
      experimental.enableSettingsViewerV2 = false;

      language = "en,de-DE";
      enableFiletypes = [ "nix" "toml" "dockerfile" "tex" "xml" "shellscript" ];
      #suggestionsTimeout = 800;
      #diagnosticLevel = "Hint";

      userWords = [ "UTF" "UTF-8" ];

      ignorePaths = [
        "package-lock.json"
        "node_modules"
        "vscode-extension"
        ".git/objects"
        ".vscode"
        ".config/*"
        "*.conf"
        "settings.json"
      ];
    };

    errorLens = {
      excludeBySource = [ "cSpell" ];
      scrollbarHackEnabled = true;
      statusBarIconsEnabled = true;
    };

    ## Git Lense
    gitlens = {
      plusFeatures.enabled = false;
      showWelcomeOnInstall = false;
      currentLine.enabled = false;
    };

    ## Neovim
    # Source: https://github.com/vscode-neovim/vscode-neovim
    /*extensions.experimental.affinity = { asvetliakov.vscode-neovim = 1; };
        vscode-neovim = {
        logLevel = "warn";
        mouseSelectionStartVisualMode = false;
        neovimClean = true;
      };*/

    ## VIM
    vim = {
      camelCaseMotion.enable = true;
      easymotionDimBackground = false;
      foldfix = true;
      highlightedyank.enable = true;
      report = 1;
      matchpairs = "(:),{:},[:],<:>";
      replaceWithRegister = false; # This sound like good stuff https://github.com/vim-scripts/ReplaceWithRegister
      smartRelativeLine = true;
      textwidth = 120; # word-wrap width with `gp`

      handleKeys = {
        # Defaults
        "<C-d>" = true;
        "<C-s>" = false; # false = Handled by VSCode
        "<C-z>" = false;

        "<C-p>" = false;
        "<C-t>" = false;
        "<C-w>" = false;
        "<C-k>" = false; # <C-k><C-o>
      };
    };

    ## Todo Tree
    todo-tree = {
      general = {
        showActivityBarBadge = true;
        statusBar = "current file";
        statusBarClickBehaviour = "cycle";
        #tags = [ "BUG" "HACK" "FIXME" "TODO" "XXX" "[ ]" ];
        tagGroups = {
          FIX = [ "FIXME" "FIXIT" ];
          "TODO" = [ "TODO" ];
        };
      };
      tree = {
        expanded = false;
        showCountsInTree = true;
        scanMode = "workspace only";
        buttons = {
          reveal = false;
          scanMode = true;
          viewStyle = false;
          export = true;
        };
      };
      regex.enableMultiLine = true;
    };

    ## Run on Save
    runOnSave.commands = [
      /*{
          match = "\\.java$";
          command = ''google-java-format --replace ''${file}'';
        }*/
    ];

    ## Live Share
    liveshare.allowGuestDebugControl = true;

    ## Recommendations from stylelint
    css.validate = false;
    less.validate = false;
    scss.validate = false;

    ##########################################################################
    # Language Plugin Settings
    ##########################################################################

    ## ESLint
    eslint.format.enable = true;

    ### Prettier
    prettier = {
      trailingComma = "es5";
      singleQuote = true;
      useTabs = true;
      tabWidth = 4;
      #useTabs = false
      #tabWidth = 2
      printWidth = 120;
    };
    #editor.defaultFormatter = "esbenp.prettier-vscode";

    ## YAML
    redhat.telemetry.enabled = null;

    ## Markdown
    markdownlint.run = "onSave";

    ### Marp
    markdown.marp = {
      enableHtml = true;
      pdf.noteAnnotations = true;
      pdf.outlines = "headings";
    };

    ## LaTeX
    latex-workshop = {
      intellisense = {
        unimathsymbols.enabled = true;
        citation.backend = "biber";
      };
      latex = {
        autoClean.run = "onFailed";
        autoBuild.run = "never";
        build.clearLog.everyRecipeStep.enabled = false;
        option.maxPrintLine.enabled = false;
        recipe.default = "latexmk (xelatex)"; # "lastUsed";
      };
      message = {
        badbox.show = false;
        information.show = true;
        log.show = true;
      };
    };

    ## Nix
    # Source: https://github.com/nix-community/vscode-nix-ide
    nix = {
      enableLanguageServer = true;
      serverPath = "${pkgs.unstable.nixd}/bin/nixd";
      serverSettings.nixd = {
        formatting.command = [ "${pkgs.unstable.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
      };
    };

    ## Bash
    bashIde.highlightParsingErrors = true;
    shellcheck.disableVersionCheck = true;

    ## Typescript
    typescript.updateImportsOnFileMove.enabled = "always";

    ## Haskell

    ## Rust
    rust-analyzer.restartServerOnConfigChange = true;

    ## Clangd
    lldb.suppressUpdateNotifications = true;
    clangd.arguments = [
      "--enable-config"
      ''--compile-commands-dir=''${workspaceFolder}''
      "--log=error"
      "--print-options"
      "--header-insertion=never"
      "--header-insertion-decorators"
      "--all-scopes-completion"
      "--completion-style=detailed"
      "--malloc-trim"
      "--background-index"
      "--clang-tidy"
    ];
    clangd.onConfigChanged = "restart";

    # Code Together
    codetogether = {
      userName = "becknik";
      virtualCursorJoin = "ownVirtualCursor";
    };

    #########################################################################
    # Language-specific Formatting section
    #########################################################################

    # VSCodium applies this format from version 1.85 on automatically when opening projects
    "[latex][markdown]" = {
      file.autoSave = "afterDelay";
      editor.wordBasedSuggestions = "off";
    };
    "[yaml]".editor.defaultFormatter = "redhat.vscode-yaml";
    "[markdown]" = {
      editor.defaultFormatter = "DavidAnson.vscode-markdownlint";
      editor.quickSuggestions = {
        comments = "off";
        strings = "off";
        other = "off";
      };
      cSpell.fixSpellingWithRenameProvider = true;
      cSpell.advanced.feature.useReferenceProviderWithRename = true;
      cSpell.advanced.feature.useReferenceProviderRemove = "/^#+\\s/"; # TODO What's this for??
    };

    "[latex]".editor.defaultFormatter = "James-Yu.latex-workshop";
    "[dockercompose]".editor.defaultFormatter = "ms-azuretools.vscode-docker";

    "[typescriptreact][typescript][javascriptreact][javascript][jsonc]".editor.defaultFormatter = "esbenp.prettier-vscode";

  };
}
