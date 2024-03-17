{ isDarwinSystem, config, lib, pkgs, ... }:

{
  imports = [
    # Make vscode settings file writable
    # Source: https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa

    (import
      (builtins.fetchurl {
        url = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375/mutability.nix";
        sha256 = "4b5ca670c1ac865927e98ac5bf5c131eca46cc20abf0bd0612db955bfc979de8";
      })
      { inherit config lib; })
    (import
      (builtins.fetchurl {
        url = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375/vscode.nix";
        sha256 = "fed877fa1eefd94bc4806641cea87138df78a47af89c7818ac5e76ebacbd025f";
      })
      { inherit config lib pkgs; })
  ];

  programs.vscode = {
    enable = true;
    # Unstable holds only version compatible to all plugins as it seems...
    package = pkgs.unstable.vscodium;

    mutableExtensionsDir = false; # Setting this to true disabled the java extensions to properly install

    # Plugins
    extensions = with pkgs.vscode-extensions; let
      cppTools = with pkgs; lib.optionals (!isDarwinSystem) [
        llvm-vs-code-extensions.vscode-clangd
        vadimcn.vscode-lldb
        ms-vscode.cmake-tools
      ];
    in
    (lib.lists.optional (!isDarwinSystem) ms-vsliveshare.vsliveshare)
    ++ [
      ## Management
      alefragnani.project-manager
      alefragnani.bookmarks
      gruntfuggly.todo-tree
      mkhl.direnv
      github.copilot
      github.copilot-chat

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
      ms-kubernetes-tools.vscode-kubernetes-tools

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
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint

      #### Shell
      mads-hartmann.bash-ide-vscode

      ### Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector

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
      #ms-vscode.cpptools
      #twxs.cmake #?
    ] ++ cppTools ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (
      [
        /* { # Mapping keymaps 1:1 between IntelliJ and VSCode sadly isn't possible, e.g. <C>+K, <C>+O not working any more
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.6.0";
          sha256 = "sha256-doBsMa4SvdFzLdKgjc4qxLOwMB2KFG73zn9a24N6CWs=";
        } */
        {
          name = "code-spell-checker-german";
          publisher = "streetsidesoftware";
          version = "2.3.1";
          sha256 = "sha256-LxgftSpGk7+SIUdZcNpL7UZoAx8IMIcwPYIGqSfVuDc=";
        }

        {
          name = "volar";
          publisher = "vue";
          version = "1.8.27";
          sha256 = "sha256-6FktlAJmOD3dQNn2TV83ROw41NXZ/MgquB0RFQqwwW0=";
        }

        {
          name = "vscode-monokai-night";
          publisher = "fabiospampinato";
          version = "1.7.0";
          sha256 = "sha256-7Vm/Z46j2GG2c2XZkAlmJ9ZCZ9og+v3tboD2Tf23gGA=";
        }

        {
          name = "theme-monokai-pro-vscode";
          publisher = "monokai";
          version = "1.2.2";
          sha256 = "sha256-xeLzzNgj/GmNnSmrwSfJW6i93++HO3MPAj8RwZzwzR4=";
        }
      ] ++

      (lib.lists.optional isDarwinSystem
        # VSCode Live Share (for MacOS etc due to incompatible package)
        {
          name = "vsliveshare";
          publisher = "MS-vsliveshare";
          version = "1.0.5905";
          #sha256 = lib.fakeSha256;
          sha256 = "sha256-y1MMO6fd/4a9PhdBpereEBPRk50CDgdiRc8Vwqn0PXY=";
        }) ++

      (lib.lists.optionals isDarwinSystem
        # Use these packages on work device only
        [
          {
            name = "vscode-checkstyle"; # Java Checkstyle
            publisher = "shengchen";
            version = "1.4.2";
            sha256 = "21c860417f42510e77a6e2eed2597cccd97a1334a7543063eed4d4a393736630";
          }

          {
            name = "vscode-spring-boot"; # Spring Boot Tools
            publisher = "vmware";
            version = "1.52.2024010405";
            sha256 = "sha256-JnSKMaSsy9qmzIFz2/U557uI1oetS3ozIqS4VQCURk0=";
          }
          {
            name = "vscode-spring-boot-dashboard";
            publisher = "vscjava";
            version = "0.13.2023072200";
            sha256 = "f3395bc26e1e79db9f2c406068987b362a746faf4093acfb1a3d274110a437bd";
          }
        ])
    );

    languageSnippets = { };

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

      ## Live Share
      liveshare.allowGuestDebugControl = true;

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
        sharedIndexes = {
          enabled = "on";
          locations = "~/.cache/.jdt/index";
        };
        configuration.runtimes =
          with lib; let
            # jdks from `programs.java` and ~/.jdks folder
            jdks = unique ([ config.programs.java.package ] ++ (attrsets.mapAttrsToList (_name: value: value.source)
              (attrsets.filterAttrs (name: _value: strings.hasInfix ".jdks/jdk-" name) config.home.file)));

            jdkToRuntime = jdks: builtins.map
              (jdk: {
                path = jdk;
                majVersion = builtins.head (builtins.splitVersion jdk.version);
                default = builtins.head (builtins.splitVersion jdk.version) == "17"; # Java language server can't handle 21 yet?
                version = "JavaSE-${builtins.head (builtins.splitVersion jdk.version)}";
              })
              jdks;
          in
          builtins.map (jdk: { inherit (jdk) path default version; }) (jdkToRuntime jdks);
      };

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

      # VSCodium applies this format from version 1.85 on autoamtically when opening projects
      "[latex][markdown]" = {
        file.autoSave = "afterDelay";
        editor.wordBasedSuggestions = "off";
      };
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
      "[latex]" = {
        editor.defaultFormatter = "James-Yu.latex-workshop";
      };
      "[dockercompose]".editor.defaultFormatter = "ms-azuretools.vscode-docker";
      "[java]".editor.defaultFormatter = "redhat.java";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
    };
  };
}
