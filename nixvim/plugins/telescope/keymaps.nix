{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>f", desc = "Find & Search", icon = "󰭎" },
      { "<leader>g", desc = "Git" },
      { "<leader>gb", icon = "  " },
      { "<leader>gs", icon = " 󱖫 " },
      { "<leader>gz", icon = "  " },
      { "<leader>g$", icon = "  " },
      { "<leader>gh", icon = "  " },

      { "<leader>ff", icon = " " },
      { "<leader>fa", icon = "  " },
      { "<leader>fg", icon = " " },
      { "<leader>fu", icon = " 󰗧" },
      { "<leader>fb", icon = "  " },
      { "<leader>fo", icon = " 󰋚 " },
      { "<leader>fh", icon = " 󰋖" },
      { "<leader>fc", icon = "  " },
      { "<leader>fk", icon = "  " },
      { "<leader>fr", icon = " \"" },
      { "<leader>fd", icon = "  " },
      { "<leader>fy", icon = "  " },
      { "<leader>fY", icon = "  " },
      { "<leader>fl", icon = " 󰦨" },
    }
  '';

  # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
  plugins.telescope.keymaps = {

    # File Pickers
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#file-pickers
    "<leader>ff" = {
      action = "git_files";
      options.desc = "Find File";
    };
    "<leader>fa" = {
      action = "find_files";
      options.desc = "Find All files";
    };
    "<leader>fu" = {
      action = "grep_string";
      options.desc = "Search string Under cursor/ selection";
      mode = mapToModeAbbr [
        "visual_select"
        "normal"
      ];
    };
    "<leader>fg" = {
      action = "live_grep";
      options.desc = "Search in live Grep";
    };

    # Vim Pickers
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#vim-pickers
    "<leader>fb" = {
      action = "buffers";
      options.desc = "Find Buffer";
    };
    "<leader>fo" = {
      action = "oldfiles";
      options.desc = "Find previously Opened file";
    };
    "<leader>fl" = {
      action = "current_buffer_fuzzy_find";
      options.desc = "Search Locally";
    };
    # "<leader>fh" = {
    #   action = "search_history";
    #   options.desc = "Find in search History results";
    # };
    "<leader>f." = {
      action = "resume";
      options.desc = "Resume";
    };

    # Vim Pickers for Settings-like Entities
    "<leader>fh" = {
      action = "help_tags";
      options.desc = "Find Help tags";
    };
    "<leader>fc" = {
      action = "commands";
      options.desc = "Find Commands (plugin & user)";
    };
    "<leader>fk" = {
      action = "keymaps";
      options.desc = "Find vim Keybindings";
    };
    # TODO this might be obsolete due to other plugins
    "<leader>fr" = {
      action = "registers";
      options.desc = "Find in vim Registers";
      mode = mapToModeAbbr [ "normal" "visual_select" ];
    };
    # "<leader>fR" = {
    #   action = "reloader";
    #   options.desc = "Find modules to Reload";
    # };

    # LSP
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#neovim-lsp-pickers
    "<leader>fd" = {
      action = "diagnostics";
      options.desc = "Find local Diagnostics";
    };
    "<leader>fy" = {
      action = "lsp_document_symbols";
      options.desc = "Find local sSymbols";
    };
    # FIXME neither seem to work
    "<leader>fY" = {
      action = "lsp_workspace_symbols"; # lsp_dynamic_workspace_symbols
      options.desc = "Find global sSymbols";
    };
    # TODO to be continued? some better suited than LSP-saga & co?

    # Git
    # inspired by Neogit default Bindings
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers
    "<leader>g$" = {
      action = "git_commits";
      # (reset <C-r>m|s|h)
      options.desc = "find in Git History";
    };
    "<leader>gb" = {
      action = "git_branches";
      options.desc = "find Git Branch";
      # <C-t>, rebase action<C-r>, create action <C-a>, switch action <C-s>, delete action <C-d> and merge action <C-y>
    };
    "<leader>gs" = {
      action = "git_status";
      options.desc = "find in Git Status";
    };
    "<leader>gz" = {
      action = "git_stash";
      options.desc = "find Git Stash";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>gh";
      action = "Telescope git_bcommits";
      options.cmd = true;
      options.desc = "find Git Commit for current buffer";

      mode = mapToModeAbbr [ "normal" ];
    }
    {
      key = "<leader>gh";
      action = "Telescope git_bcommits_range";
      options.cmd = true;
      options.desc = "find Git Commits for selection";

      mode = mapToModeAbbr [ "visual_select" ];
    }
  ];
}
