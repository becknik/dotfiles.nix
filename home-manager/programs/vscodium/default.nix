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

    ./extensions.nix
    ./snippets.nix
    ./settings-user.nix
    ./settings-extensions.nix
  ];

  catppuccin.vscode.enable = lib.mkForce false;
  programs.vscode = {
    enable = lib.mkForce true;
    # Only unstable version is compatible with all plugins as it seems...
    # package = pkgs.unstable.vscodium;

    keybindings = [

      # TODO
      # {
      # key = "right";
      # command = "github.copilot.acceptSuggestion";
      # when = "editorTextFocus && github.copilot.inlineSuggestionVisible";
      # }

      # Toggle insert snippet mode to enable wrapper-snippets
      {
        key = "ctrl+shift+s";
        command = "editor.action.insertSnippet";
        when = "editorTextFocus && !suggestWidgetVisible";
      }

      # Use Vim-like <C-p>/ <C-n> in file selector etc.
      {
        key = "ctrl+p";
        command = "workbench.action.quickOpenSelectPrevious";
        when = "inQuickOpen";
      }
      {
        key = "ctrl+n";
        command = "workbench.action.quickOpenSelectNext";
        when = "inQuickOpen";
      }

      # reenable Vim-Plugins <C-p> & <C-n> for autosuggestions only
      {
        key = "ctrl+p";
        command = "selectPrevSuggestion";
        when = "editorTextFocus && suggestWidgetVisible";
      }
      {
        key = "ctrl+n";
        command = "selectNextSuggestion";
        when = "editorTextFocus && suggestWidgetVisible";
      }


      # fix Copilot suggestion overwriting suggestion autostopps on tab
      {
        key = "tab";
        command = "jumpToNextSnippetPlaceholder";
        when = "editorTextFocus && inSnippetMode && !suggestWidgetVisible";
      }
      {
        key = "shift+tab";
        command = "jumpToPrevSnippetPlaceholder";
        when = "editorTextFocus && inSnippetMode && !suggestWidgetVisible";
      }
      # re-enable selection of copilot suggestions inside of autostopps
      {
        key = "ctrl+enter";
        command = "editor.action.inlineSuggest.commit";
        when = "editorTextFocus && inlineSuggestionVisible && inSnippetMode";
      }

      # Harpoon

      # fix Vim-Plugin <C-e> not working in normal mode
      # {
      #   key = "ctrl+e";
      #   command = "vscode-harpoon.addEditor";
      # }
      {
        key = "alt+e";
        command = "vscode-harpoon.editEditors";
      }
      {
        key = "alt+p";
        command = "vscode-harpoon.editorQuickPick";
      }

      {
        key = "alt+1";
        command = "vscode-harpoon.gotoEditor1";
      }
      {
        key = "alt+2";
        command = "vscode-harpoon.gotoEditor2";
      }
      {
        key = "alt+3";
        command = "vscode-harpoon.gotoEditor3";
      }
      {
        key = "alt+4";
        command = "vscode-harpoon.gotoEditor4";
      }
    ];

  };
}
