{ ... }:

{
  programs.vscode.userSettings = {
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
        "source.addMissingImports"
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

      ## Suggestions & Completion
      tabCompletion = true; # double tab => snippet selected without opening suggestions
      suggestOnTriggerCharacters = true;

      suggest = {
        preview = true;
        showStatusBar = true;
        localityBonus = true;
        filterGraceful = true;
        snippetsPreventQuickSuggestions = true;
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
  };
}
