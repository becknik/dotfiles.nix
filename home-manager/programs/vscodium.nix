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
        #curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/fabiospampinato/vsextensions/vscode-monokai-night/latest/vspackage | sha256sum # TODO this wont work atm...
				# https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-monokai-night
        sha256 = "ed59bf678ea3d861b67365d990096627d64267da20fafded6e80f64dfdb78060";
      }
      { # German cSpell dictionary
        name = "code-spell-checker-german";
        publisher = "streetsidesoftware";
        version = "latest";
        # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/streetsidesoftware/vsextensions/code-spell-checker-german/latest/vspackage
				# https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker-german&ssr=false#version-history
        sha256 = "ac09b7a5c2e7e87a169e159ea0aff40fdaf9a18f53210db710c877e6bbab8038";
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
			#settingsSync.ignoredSettings = ["-window.zoomLevel"];

			# Security/ Project Trust:
			security.workspace.trust = {
				untrustedFiles = "open";
				enabled = false;
				startupPrompt = "never";
			};

			# Workbench Settings:
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

			# Explorer settings:
			explorer = {
				confirmDelete = false;
				confirmDragAndDrop = false;
				incrementalNaming = "smart";
				#openEditors.sortOrder = "alphabetical"; # defaults to editorOrder
			};

			# Editor Settings:
			zenMode = {
				hideActivityBar = false;
				hideLineNumbers = false;
				restore = false;
			};

			editor = {
				wordWrap = "on";
				rulers = [ { column = 80; } { column = 120; } ];
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
				glyphMargin = false;
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

			# Plugin Settings

			## Etc:
			code-runner = {
				clearPreviousOutput = true;
				enableAppInsights = false;
			};

			projectManager = {
				git.baseFolders = [ "~/devel/own" "~/devel/foreign" "~/devel/ide" ];
				confirmSwitchOnActiveWindow = "onlyUsingSideBar";
			};

			path-intellisense = {
				autoTriggerNextSuggestion = true;
				extensionOnImport = true;
				showHiddenFiles = true;
			};

			## cSpell:
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

			## Prettier # TODO
			prettier = {
				printWidth = 120;
				tabWidth = 4;
				useTabs = true;
			};
			#editor.defaultFormatter = "esbenp.prettier-vscode";

			## Neovim
			# Source: https://github.com/vscode-neovim/vscode-neovim
			extensions.experimental.affinity = { asvetliakov.vscode-neovim = 1; };
			vscode-neovim = {
				logLevel = "warn";
				mouseSelectionStartVisualMode = false; # TODO changed this
				neovimClean = true;
				#neovimExecutablePaths.darwin = "";
			};

			## Project Manager
			projectManager = {
				groupList = true;
				ignoreProjectsWithinProjects = true;
				openInNewWindowWhenClickingInStatusBar = true;
				showParentFolderInfoOnDuplicates = true;
				sortList = "Recent";
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

			# Code Snap
			codesnap = {
				realLineNumbers = true;
				showWindowTitle = true;
				transparentBackground = true;
				shutterAction = "copy";
			};

			# Marp
			markdown.marp = {
				enableHtml = true;
				pdf.noteAnnotations = true;
				pdf.outlines = "headings";
			};

			## Languages

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
			bashIde.highlightParsingErrors = true;
			shellcheck.disableVersionCheck = true;

			### Java
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
			};
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

			### Rust
			rust-analyzer.restartServerOnConfigChange = true;
			"[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";

			### Nix
      nix = {
        enableLanguageServer = true;
        serverPath = "nil";
      };

			# Messy Settings Part

			lldb.suppressUpdateNotifications = true;
			terminal.integrated.scrollback = 5000;
			outline.collapseItems = "alwaysCollapse";
			files.watcherExclude = { # Scala Metals
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
