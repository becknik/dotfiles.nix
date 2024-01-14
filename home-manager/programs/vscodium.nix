{ config, lib, pkgs, system, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false; # Setting this to true disabled the java extensions to properly install

    # Plugins
    extensions = with pkgs.vscode-extensions; [

      ## Management
      alefragnani.project-manager
      alefragnani.bookmarks
      gruntfuggly.todo-tree
      mkhl.direnv
      #(lib.optional (system  == "x86_64-linux") ms-vsliveshare.vsliveshare) # TODO
      ms-vsliveshare.vsliveshare

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
      ms-azuretools.vscode-docker

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
      ms-python.vscode-pylance
      ms-pyright.pyright

      #### JS/TS
      esbenp.prettier-vscode

      #### Shell
      mads-hartmann.bash-ide-vscode

      ### Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector # 1.0.10 is 17 months newer than 1.0.9 & not in stable nixpkgs

      ### LaTeX
      james-yu.latex-workshop

      ### Haskell
      justusadam.language-haskell # Syntax highlighting
      haskell.haskell # Linting etc.

      ### JVM
      scalameta.metals
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-test
      vscjava.vscode-maven
      vscjava.vscode-java-dependency
      vscjava.vscode-gradle
      vscjava.vscode-spring-initializr

      ### Rust
      rust-lang.rust-analyzer

      ### Cpp
      llvm-vs-code-extensions.vscode-clangd
      vadimcn.vscode-lldb
      #ms-vscode.cpptools
      #twxs.cmake #?
      ms-vscode.cmake-tools
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

      /* (lib.optional (system != "x86_64-linux") { # TODO
        # VSCode Live Share (for MacOS etc due to incompatible package)
        name = "vsliveshare";
        publisher = "MS-vsliveshare";
        version = "1.0.5900";
        #sha256 = lib.fakeSha256;
      }) */

      {
        # German cSpell dictionary
        name = "code-spell-checker-german";
        publisher = "streetsidesoftware";
        version = "2.3.1";
        #sha256 = lib.fakeSha256;
        sha256 = "sha256-LxgftSpGk7+SIUdZcNpL7UZoAx8IMIcwPYIGqSfVuDc=";
      }

      {
        # Monokai Night Theme
        name = "vscode-monokai-night";
        publisher = "fabiospampinato";
        version = "1.7.0";
        #sha256 = lib.fakeSha256;
        sha256 = "sha256-7Vm/Z46j2GG2c2XZkAlmJ9ZCZ9og+v3tboD2Tf23gGA=";
      }

      /*{ # Auto Completion IntelliCode
        name = "vscodeintellicode";
        publisher = "VisualStudioExptTeam";
        version = "1.2.30";
        sha256 = lib.fakeSha256;
      }*/

      /*{
        # Java Checkstyle
        name = "vscode-checkstyle";
        publisher = "shengchen";
        version = "1.4.2";
        #sha256 = lib.fakeSha256;
        sha256 = "21c860417f42510e77a6e2eed2597cccd97a1334a7543063eed4d4a393736630";
      }*/

      /*{ # Spring Boot Tools
        name = "vscode-spring-boot";
        publisher = "vmware";
        version = "1.52.2024010405";
        sha256 = lib.fakeSha256;
      }
      { # Spring Boot Dashboard
        name = "vscode-spring-boot-dashboard";
        publisher = "vscjava";
        version = "0.13.2023072200";
        #sha256 = lib.fakeSha256;
        sha256 = "f3395bc26e1e79db9f2c406068987b362a746faf4093acfb1a3d274110a437bd";
      }
      { # Spring Boot Initializer
        name = "vscode-spring-initializr";
        publisher = "vscjava";
        version = "0.11.2023070103";
        #sha256 = lib.fakeSha256;
      }*/

      # Missing: Monokai Pro, Vue Volar
    ];

    languageSnippets = { };

    keybindings = [ ];


    userSettings = {

      #########################################################################
      # VSCode Settings
      #########################################################################

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

        tips.enabled = false;

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

        parameterHints.cycle = true;
        dragAndDrop = false;
        copyWithSyntaxHighlighting = true;

        definitionLinkOpensInPeek = true;

        linkedEditing = true;
        formatOnSave = false;
        formatOnPaste = true;
        formatOnSaveMode = "modifications"; # modificationsIfAvailable
        codeActionsOnSave = {
          source.organizeImports = true;
        };

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

        ## Typography & Fonts
        lineHeight = 0;
        fontFamily = "'Fira Code Nerd'";
        fontLigatures = true;
        fontVariations = true;
        guides.bracketPairs = "active";
        guides.highlightActiveBracketPair = false;
        #fontWeight = "400"; # Does not work properly

        ## Suggestions
        suggest.preview = true;
        suggest.showStatusBar = true;
        suggest.localityBonus = true;
        suggest.filterGraceful = true;
      };

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
        autoSave = "afterDelay"; # autoSaveDelay = 1000ms
        restoreUndoStack = false;
        simpleDialog.enable = true;
        hotExit = "off";
        trimTrailingWhitespace = true;
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
        delay = 500;
        delayMode = "debounce";
        excludeBySource = [
          "cSpell"
        ];
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

      ## Docker
      docker = {
        composeCommand = "podman compose";
        dockerPath = "podman";
      };

      ##########################################################################
      # Language Plugin Settings
      ##########################################################################

      ## Linting

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
        serverPath = "nil";
        serverSettings.nil = {
          formatting.command = [ "nixpkgs-fmt" ];
        };
        /*serverPath = "nixd";
          serverSettings.nixd = {
            formatting.command = "nixpkgs-fmt";
            options = {
            enable = true;
          };
        };*/
      };

      ## Bash
      bashIde.highlightParsingErrors = true;
      shellcheck.disableVersionCheck = true;

      ## Haskell

      ## Java
      redhat.telemetry.enabled = false;
      java = {
        autobuild.enabled = false;
        codeGeneration = {
          generateComments = true;
          hashCodeEquals.useInstanceof = true;
          useBlocks = true;
        };
        project = {
          encoding = "setDefault";
          importOnFirstTimeStartup = "automatic";
        };
        jdt.ls.androidSupport.enabled = "off";
        sharedIndexes.enabled = "off";
        # Automatically add all home-manager installed jdks as runtimes and selects the highest version as `default`
        configuration.runtimes =
          let
            # helpers
            addMajVersion = jdk: {
              path = jdk;
              majVersion = builtins.head (builtins.splitVersion jdk.version);
            };
            majVersionComp = jdk1: jdk2: builtins.lessThan jdk1.majVersion jdk2.majVersion;

            # perhaps all packages with a `jre`-attribute are jdks
            jdks = (builtins.filter (pkg: builtins.hasAttr "jre" pkg) (config.home.packages));
            # TODO `++ config.environment.systemPackages` not working in home-manager module
            jdksTransformed = builtins.map addMajVersion jdks;
            jdksSorted = builtins.sort majVersionComp jdksTransformed;
          in
          builtins.map
            (jdk: {
              inherit (jdk) path;
              version = "JavaSE-${jdk.majVersion}";
              default = if (jdk == builtins.head jdksSorted) then true else false;
            }
            )
            jdksSorted;
      };

      ## Rust
      rust-analyzer.restartServerOnConfigChange = true;

      # Messy Settings Part
      lldb.suppressUpdateNotifications = true;
      outline.collapseItems = "alwaysCollapse";
      files.watcherExclude = {
        # Scala Metals
        "**/.bloop" = true;
        "**/.metals" = true;
        "**/.ammonite" = true;
      };

      ## Clangd
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

      # MS C++ Plugin
      /*C_Cpp.intelliSenseEngine = "disabled";
        "[cpp]" = {
        #"editor.defaultFormatter": "llvm-vs-code-extensions.vscode-clangd",
        editor.wordBasedSuggestions = true;
        editor.defaultFormatter = "llvm-vs-code-extensions.vscode-clangd";
        };
        C_Cpp.autocompleteAddParentheses = true;
        C_Cpp.default.cppStandard = "c++20";
        C_Cpp.default.cStandard = "c17";
        C_Cpp.default.intelliSenseMode = "linux-clang-x86";
        C_Cpp.loggingLevel = "Information";
        C_Cpp.default.compilerPath = "/usr/bin/g++";
        C_Cpp.default.customConfigurationVariables = {};
        C_Cpp.codeAnalysis.updateDelay = 500;
        C_Cpp.inlayHints.referenceOperator.enabled = true;
        C_Cpp.intelliSenseUpdateDelay = 500;
        C_Cpp.workspaceParsingPriority = "medium";
        C_Cpp.dimInactiveRegions = false;
        C_Cpp.default.compilerArgs = [
        "-std=c++20"
        "-march=native"
        "-fuse-ld=mold"
        "-O0"
        "-ggdb"
        "-pedantic-errors"
        "-Wall"
        "-Wextra"
        "-Weffc++"
        "-Wsign-conversion"
        ];
        C_Cpp.clang_format_path = "/usr/bin/clang-format";
        C_Cpp.clang_format_sortIncludes = false;
        C_Cpp.clang_format_style = "Visual Studio";
      C_Cpp.errorSquiggles = "enabled";*/

      # Sync Plugin
      #sync.gist = "461947d6481e2c78445a11486a0b11a7";
      #sync.autoDownload = true;
      #sync.autoUpload = true;

      # Language-specific Formatting section

      # VSCodium seems to make this change from version 1.85 autoamtically when opening projects
      "[markdown]" = {
        editor.defaultFormatter = "DavidAnson.vscode-markdownlint";
        editor.quickSuggestions = {
          comments = "off";
          strings = "off";
          other = "off";
        };
        cSpell.fixSpellingWithRenameProvider = true;
        cSpell.advanced.feature.useReferenceProviderWithRename = true;
        cSpell.advanced.feature.useReferenceProviderRemove = "/^#+\\s/"; # TODO Whats this for??
      };
      "[dockercompose]".editor.defaultFormatter = "ms-azuretools.vscode-docker";
      "[latex]" = {
        editor.defaultFormatter = "James-Yu.latex-workshop";
      };
      "[latex][markdown]".editor.wordBasedSuggestions = "off";
      "[java]".editor.defaultFormatter = "redhat.java";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
    };
  };
}
