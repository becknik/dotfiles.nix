{ config, lib, pkgs, ... }:

{
  imports = [
    # Make vscode settings file writable
    # Source: https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
    (import
      (builtins.fetchurl {
        url = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375/vscode.nix";
        sha256 = "fed877fa1eefd94bc4806641cea87138df78a47af89c7818ac5e76ebacbd025f";
      })
      { inherit config lib pkgs; })
  ];

  programs.vscode = {
    enable = true;
    # Only unstable version is compatible with all plugins as it seems...
    package = pkgs.unstable.vscodium;

    # Plugins
    extensions = with pkgs.unstable.vscode-extensions; [
      ## Management
      ms-vsliveshare.vsliveshare
      alefragnani.project-manager
      alefragnani.bookmarks
      gruntfuggly.todo-tree
      mkhl.direnv
      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github

      ## Editor Config, Autocompletion, etc.
      vscodevim.vim
      #asvetliakov.vscode-neovim
      formulahendry.code-runner
      streetsidesoftware.code-spell-checker
      christian-kohler.path-intellisense
      usernamehw.errorlens

      ## Eye Candy
      adpyke.codesnap
      johnpapa.vscode-peacock

      ### Git
      eamodio.gitlens
      mhutchie.git-graph

      ## Deployment
      github.vscode-github-actions
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools

      ### Interface

      apollographql.vscode-apollo
      # graphql => graphql-syntax
      # graphql.vscode-graphql
      # graphql.vscode-graphql-syntax

      ## Languages

      ### Markup
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint
      redhat.vscode-yaml
      tamasfe.even-better-toml
      gencer.html-slim-scss-css-class-completion
      redhat.vscode-xml

      ### Scripting
      ms-python.python
      ms-python.vscode-pylance #ms-pyright.pyright is included in pylance

      #### JS/TS
      denoland.vscode-deno
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss

      #### Shell
      # has shellfmt & shellcheck support, but can't access binaries
      (mads-hartmann.bash-ide-vscode.overrideAttrs (_oldAttrs: {
        buildInputs = [ pkgs.shellcheck pkgs.shfmt ];
      }))

      ### Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector

      ### LaTeX
      james-yu.latex-workshop

      ### Haskell
      justusadam.language-haskell # Syntax highlighting
      haskell.haskell # Linting etc.

      ### Rust
      rust-lang.rust-analyzer

      ### Cpp
      llvm-vs-code-extensions.vscode-clangd
      # vadimcn.vscode-lldb
      ms-vscode.cmake-tools
      #ms-vscode.cpptools
      #twxs.cmake #?
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (
      [
        {
          name = "vscode-expo-tools";
          publisher = "expo";
          version = "1.5.0";
          sha256 = "sha256-bjVebozUfwEsoclEjDpGYJ108bLJJaQhoBDpFcZ/bI8=";
        }
        {
          name = "toggle-case";
          publisher = "ryanlaws";
          version = "1.0.2";
          sha256 = "sha256-tvgLHSKmX3FBLwi4JikJR4PUieK6iKGzBMj+Zz58SFI=";
        }
        {
          name = "git-worktrees";
          publisher = "GitWorktrees";
          version = "2.2.0";
          sha256 = "sha256-bk0poO9REcm7r3D0i9Z2DDsWjDlHXfI/kKvvwOwAgbg=";
        }

        {
          name = "code-spell-checker-german";
          publisher = "streetsidesoftware";
          version = "2.3.2";
          sha256 = "sha256-40Oc6ycNog9cxG4G5gCps2ADrM/wLuKWFrD4lnd91Z4=";
        }

        {
          name = "vscode-monokai-night";
          publisher = "fabiospampinato";
          version = "1.7.1";
          sha256 = "sha256-GDLnZ/pL8XQjg1oYNHvAB2xgS3vSq4JA4DvmuXcVuPA=";
        }
        {
          name = "theme-monokai-pro-vscode";
          publisher = "monokai";
          version = "2.0.5";
          sha256 = "sha256-H79KlUwhgAHBnGucKq8TJ1olDl0dRrq+ullGgRV27pc=";
        }
      ]
    );

    languageSnippets = {
      javascriptreact = builtins.fromJSON (builtins.readFile ./vscodium/snippets-react.json);
      typescriptreact = builtins.fromJSON (builtins.readFile ./vscodium/snippets-react.json);
    };

    keybindings = [ ];

    userSettings = {

      #########################################################################
      # VSCode Settings
      #########################################################################

      locale = "en";

      # Main Settings
      window = {
        zoomLevel = 1;
        restoreWindows = "none";
        openFilesInNewWindow = "default";
      };
      telemetry.telemetryLevel = "error";
      #settingsSync.ignoredSettings = ["-window.zoomLevel"];

      # Security/ Project Trust
      security.workspace.trust = {
        untrustedFiles = "open";
        enabled = false;
        startupPrompt = "never";
      };

      # Workbench Settings
      workbench = {
        startupEditor = "none";
        reduceMotion = "on";
        sideBar.location = "right";

        tips.enabled = true;

        tree.enableStickyScroll = true;
        #editor.autoLockGroups = {};
        #commandPalette.history = 0; # defaults to 50
        enableExperiments = false;
        sash.hoverDelay = 250;

        editor = {
          enablePreview = false; # Don't know if this was good, removed recursive fonts
          highlightModifiedTabs = true;
        };

        editorAssociations = {
          "*.pdf" = "latex-workshop-pdf-hook";
        };
      };

      # Explorer settings
      explorer = {
        confirmDelete = false;
        confirmDragAndDrop = false;
        incrementalNaming = "smart";
        #openEditors.sortOrder = "alphabetical"; # defaults to editorOrder
      };

      # Editor Settings
      zenMode = {
        hideActivityBar = false;
        hideLineNumbers = false;
        restore = false;
      };

      editor = {
        wordWrap = "on";
        rulers = [{ column = 80; } { column = 120; }];
        autoClosingDelete = "always"; # delete adjacent braces or "
        stickyTabStops = true;
        tabSize = 2;

        parameterHints.cycle = true;
        dragAndDrop = false;
        copyWithSyntaxHighlighting = true;

        definitionLinkOpensInPeek = true;

        linkedEditing = true;
        formatOnSave = true;
        formatOnPaste = true;
        formatOnSaveMode = "modificationsIfAvailable";
        codeActionsOnSave = [
          "source.organizeImports"
          "source.fixAll.eslint"
        ];

        accessibilitySupport = "off";
        unfoldOnClickAfterEndOfLine = true;
        fastScrollSensitivity = 3;
        glyphMargin = true;
        hover.delay = 350;
        inlayHints.padding = true;
        matchBrackets = "always";
        multiCursorPaste = "full";
        renderLineHighlight = "all";
        renderWhitespace = "boundary";
        fontSize = 13;
        lineNumbers = "on";

        #insertSpaces = false; # overwritten by editor.detectIndentation
        #unicodeHighlight.nonBasicASCII = false;
        #unicodeHighlight.includeComments = false;

        ## Eye Candy
        cursorBlinking = "smooth";
        minimap.renderCharacters = false;
        #roundedSelection = false; # Defaults to true
        stickyScroll.enabled = true;

        ## Typography & Fonts
        lineHeight = 0;
        fontFamily = "'Fira Code Nerd'";
        fontLigatures = true;
        fontVariations = true;
        guides.bracketPairs = "active";
        guides.highlightActiveBracketPair = false;
        #fontWeight = "400"; # Does not work properly

        ## Suggestions
        suggest = {
          preview = true;
          showStatusBar = true;
          localityBonus = true;
          filterGraceful = true;
        };
      };
      outline.collapseItems = "alwaysCollapse";

      # Search
      search = {
        showLineNumbers = true;
        smartCase = true;
        seedWithNearestWord = true;
      };

      # Sidebar

      ## Files
      files = {
        trimFinalNewlines = true;
        autoSave = "onFocusChange";
        autoSaveDelay = 5000; # For language-specific `autoSave = "afterDelay";` overrides
        autoSaveWhenNoErrors = false; # default value
        restoreUndoStack = false;
        simpleDialog.enable = true;
        hotExit = "off";
        trimTrailingWhitespace = true;
        watcherExclude = {
          # Scala Metals
          "**/.bloop" = true;
          "**/.metals" = true;
          "**/.ammonite" = true;
        };
      };

      # Git
      git = {
        confirmSync = false;
        inputValidationSubjectLength = 72;
        autofetch = true;
        openRepositoryInParentFolders = "always";
      };

      # Terminal
      terminal = {
        integrated.scrollback = 5000;
        enablePersistentSessions = false;
      };

      # Debugging

      # https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_auto-attach
      debug.javascript.autoAttachFilter = "onlyWithFlag"; # triggered with `--inspect-brk` or `--inspect` cli flags


      #########################################################################
      # General Plugin Settings
      #########################################################################

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
  };
}
