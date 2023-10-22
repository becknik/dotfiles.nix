{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false; # TODO Check if the settings.json is properly linted now

		# Plugins
    extensions = with pkgs.vscode-extensions; [

      ## Management
      alefragnani.project-manager
      alefragnani.bookmarks
      gruntfuggly.todo-tree

      ## Meta-code level
      #vscodevim.vim
      asvetliakov.vscode-neovim
      formulahendry.code-runner
      streetsidesoftware.code-spell-checker
      christian-kohler.path-intellisense

      ## Eye Candy
      adpyke.codesnap
      johnpapa.vscode-peacock
      #dracula-theme.theme-dracula

      ## Languages
      #github.copilot

      ### Markup
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint
      redhat.vscode-yaml
      tamasfe.even-better-toml
      gencer.html-slim-scss-css-class-completion
      redhat.vscode-xml

      ### Scripting
      ms-python.python

      #### JS/TS
      esbenp.prettier-vscode

      #### Shell
      mads-hartmann.bash-ide-vscode

      ### Nix
      jnoortheen.nix-ide

      ### LaTeX
      james-yu.latex-workshop

      ### JVM
      scalameta.metals
			redhat.java

      ### Rust
      rust-lang.rust-analyzer

      ### Cpp
      llvm-vs-code-extensions.vscode-clangd
      vadimcn.vscode-lldb
      #ms-vscode.cpptools
      #twxs.cmake #?
      ms-vscode.cmake-tools

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      { # Monokai Night Theme
        name = "vscode-monokai-night";
        publisher = "fabiospampinato";
        version = "latest";
        sha256 = "ed59bf678ea3d861b67365d990096627d64267da20fafded6e80f64dfdb78060";
      }
      { # German cSpell dictionary
        name = "code-spell-checker-german";
        publisher = "streetsidesoftware";
        version = "latest";
        sha256 = "174ca44df140652a967e7b5829658482d5322e29814f44347e2136d7dfd8a86b";
      }
      # Monokai Pro
      # Vue volar
      # settings-sync (now obsolete :) )
    ];

    languageSnippets = {};

    keybindings = [];

    userTasks = {}; # TODO what is this?

		# VSCode Settings:

    userSettings = {
			# Main Settings:
      window = {
				zoomLevel = 1;
			  restoreWindows = "none";
				openFilesInNewWindow = "default";
			};
			telemetry.telemetryLevel = "error";
			## Sync:
			#settingsSync.ignoredSettings = ["-window.zoomLevel"];

			# Security:
			security.workspace.trust = {
				untrustedFiles = "open";
				enabled = false;
				startupPrompt = "never";
			};

			# Workbench Settings:
			workbench = {
				sideBar.location = "right";
				startupEditor = "none";
				reduceMotion = "on";
				tips.enabled = false;
				editor.autoLockGroups = {};
				editor.defaultBinaryEditor = "hexEditor.hexedit";
				commandPalette.history = 0;
				enableExperiments = false;
				sash.hoverDelay = 250;
				editorAssociations."*.pdf" = "latex-workshop-pdf-hook";
				editor.enablePreview = false; # Don't know if this was good, removed recursive fonts
				editor.highlightModifiedTabs = true;
			};

			# Explorer settings:
			explorer = {
				confirmDelete = false;
				confirmDragAndDrop = false;
				incrementalNaming = "smart";
				openEditors.sortOrder = "alphabetical";
			};

			# Editor Settings:
			zenMode = {
				hideActivityBar = false;
				hideLineNumbers = false;
				restore = false;
			};
			editor = {
				wordWrap = "on";
				insertSpaces = false;
				accessibilitySupport = "off";
				autoClosingDelete = "always";
				codeActionsOnSave.source.organizeImports = true;
				formatOnSave = false;
				formatOnSaveMode = "modificationsIfAvailable";
				definitionLinkOpensInPeek = true;
				linkedEditing = true;
				parameterHints.cycle = true;
				unfoldOnClickAfterEndOfLine = true;
				unicodeHighlight.includeComments = false;
				formatOnPaste = true;
				copyWithSyntaxHighlighting = true;
				dragAndDrop = false;
				fastScrollSensitivity = 3;
				glyphMargin = false;
				hover.delay = 350;
				inlayHints.padding = true;
				matchBrackets = "always";
				multiCursorPaste = "full";
				renderLineHighlight = "all";
				renderWhitespace = "boundary";
				rulers = [ { column = 80; } { column = 120; } ];
				stickyTabStops = true;
				fontSize = 13;
				lineNumbers = "on";
				unicodeHighlight.nonBasicASCII = false;

				## Eye Candy
				cursorBlinking = "smooth";
				roundedSelection = false;
        minimap.renderCharacters = false;

				## Typography & Fonts
				lineHeight = 0;
				fontFamily = "'Fira Code Nerd'";
				fontVariations = true;
				fontWeight = "400"; # Does not work properly
				fontLigatures = true;
				guides.bracketPairs = "active";
				guides.highlightActiveBracketPair = false;

				## Suggestions
				suggest.preview = true;
				suggest.showStatusBar = true;
				suggest.localityBonus = true;
				suggest.filterGraceful = true;
			};

			# Search:
			search = {
				showLineNumbers = true;
				smartCase = true;
				seedWithNearestWord = true;
			};

			# Sidebar

			## Files
			files = {
				trimFinalNewlines = true;
				autoSave = "afterDelay";
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

			# Plugin Settings

			## Etc:
			code-runner = {
				clearPreviousOutput = true;
				enableAppInsights = false;
			};

			projectManager = {
				git.baseFolders = [ "~/git-own" "~/git-foreign" ];
				confirmSwitchOnActiveWindow = "onlyUsingSideBar";
			};

			path-intellisense = {
				autoTriggerNextSuggestion = true;
				showHiddenFiles = true;
			};

			## cSpell:
			cSpell = {
				enabled = true;
				enableFiletypes = [ "nix" "toml" "dockerfile" "tex" "xml" "shellscript" ];
				caseSensitive = true;
				suggestionsTimeout = 800;
				language = "en,de-DE";
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
				diagnosticLevel = "Hint"; # TODO
			};

			## Prettier # TODO
			prettier = {
				printWidth = 120;
				tabWidth = 4;
				useTabs = true;
			};
			#editor.defaultFormatter = "esbenp.prettier-vscode";

			## Neovim
			vscode-neovim = {
				logLevel = "warn";
				mouseSelectionStartVisualMode = true;
				#neovimExecutablePaths.darwin = "";
			};
			# Source: https://github.com/vscode-neovim/vscode-neovim
			extensions.experimental.affinity = { asvetliakov.vscode-neovim = 1; };

			## Project Manager
			projectManager = {
				ignoreProjectsWithinProjects = true;
				openInNewWindowWhenClickingInStatusBar = true;
				showParentFolderInfoOnDuplicates = true;
			};

			## Todo Tree
			todo-tree = {
				general = {
					showActivityBarBadge = true;
					statusBar = "current file";
					tags = ["BUG" "HACK" "FIXME" "TODO" "XXX" "[ ]" "[x]" "todo"];
					statusBarClickBehaviour = "cycle";
				};
				tree = {
					expanded = true;
					showCountsInTree = true;
					buttons.reveal = false;
					buttons.scanMode = true;
					buttons.viewStyle = false;
					scanMode = "workspace only";
					buttons.export = true;
				};
				regex.enableMultiLine = true;
			};

			## Language

			### Markdown
			"[markdown]" = {
				editor.unicodeHighlight.invisibleCharacters = false;
				editor.defaultFormatter = "DavidAnson.vscode-markdownlint";
				editor.quickSuggestions = {
					comments = "off";
					strings = "off";
					other = "off";
				};
				editor.wordBasedSuggestions = false;
				cSpell.fixSpellingWithRenameProvider = true;
				cSpell.advanced.feature.useReferenceProviderWithRename = true;
				cSpell.advanced.feature.useReferenceProviderRemove = "/^#+\\s/"; # TODO ; weg?
			};
			markdownlint.run = "onSave";

			### Bash:
			bashIde = {
				highlightParsingErrors = true;
				#shellcheckPath = "/usr/bin/shellcheck";
			};
			shellcheck.disableVersionCheck = true;

			### Java
			redhat.telemetry.enabled = false;
			java = {
				autobuild.enabled = false;
				codeGeneration.generateComments = true;
				codeGeneration.hashCodeEquals.useInstanceof = true;
				codeGeneration.useBlocks = true;
				jdt.ls.androidSupport.enabled = "off";
				project.encoding = "setDefault";
				project.importOnFirstTimeStartup = "automatic";
				sharedIndexes.enabled = "off";
			};
			#java.jdt.ls.java.home = "/usr/lib/jvm/java-17-openjdk/";
			#"java.format.settings.profile": "Custom Settings",
			#"java.format.settings.url": "~/settings/idea-java-formatter-settings.xml",
			"[java]" = {
				editor.defaultFormatter = "redhat.java";
			};

			### LaTeX:
			"[latex]" = {
				editor.wordBasedSuggestions = false;
				editor.defaultFormatter = "James-Yu.latex-workshop";
			};
			latex-workshop = {
				intellisense.unimathsymbols.enabled = true;
				latex.autoClean.run = "onFailed";
				latex.autoBuild.run = "never";
				message.badbox.show = false;
				message.information.show = true;
				message.log.show = true;
				latex.build.clearLog.everyRecipeStep.enabled = false;
        latex.option.maxPrintLine.enabled = false;
        latex.recipe.default = "lastUsed";
			};

			# Messy Settings Part

      nix = {
        enableLanguageServer = true;
        serverPath = "nil";
      };
			rust-analyzer.restartServerOnConfigChange = true;
			"[rust]" = { editor.defaultFormatter = "rust-lang.rust-analyzer"; };
			lldb.suppressUpdateNotifications = true;
			codesnap.realLineNumbers = true;
			codesnap.showWindowTitle = true;
			codesnap.transparentBackground = true;
			codesnap.shutterAction = "copy";
			terminal.integrated.scrollback = 5000;
			files.watcherExclude = {
				"**/.bloop" = true;
				"**/.metals" = true;
				"**/.ammonite" = true;
			};

			### Clangd
			/*clangd.path = "/usr/bin/clangd";
			clangd.arguments = [
				"--enable-config"
				''--compile-commands-dir=''${workspaceFolder}'' # TODO does this escape the interpolation
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
			clangd.onConfigChanged = "restart"; */

			# VIM Plugin:
			#vim.camelCaseMotion.enable = true;
			#vim.easymotionDimBackground = false;
			#vim.foldfix = true;
			#vim.highlightedyank.enable = true;
			#vim.report = 1;

			# Code Together:
			#codetogether.userName = "becknik";
			#codetogether.virtualCursorJoin = "ownVirtualCursor";


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

    };
  };
}
