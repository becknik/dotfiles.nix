{ mapToModeAbbr, withDefaultKeymapOptions, ... }:

{
  extraConfigLua = ''
    wk.add {
      { "<leader>f", desc = "Find & Search", icon = "󰭎 " },
      { "<leader>fa", icon = "  " },
      { "<leader>fu", icon = " 󰗧" },
      { "<leader>fo", icon = " 󰋚 " },
      { "<leader>fh", icon = " 󰋖" },
      { "<leader>fc", icon = "  " },
      { "<leader>fk", icon = "  " },
      { "<leader>fr", icon = " \"" },
      { "<leader>fR", icon = " 󱄋 " },
      { "<leader>fl", icon = " 󰦨" },

      { "F", icon = " " },
    }
  '';

  # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
  plugins.telescope.keymaps = {
    # File Pickers
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#file-pickers
    "<leader>fa" = {
      action = "find_files";
      options.desc = "Find All files";
    };
    "<leader>fu" = {
      action = "grep_string theme=ivy";
      options.desc = "Search string Under cursor/ selection";
      mode = mapToModeAbbr [
        "visual_select"
        "normal"
      ];
    };
    "F" = {
      action = "live_grep theme=ivy";
      options.desc = "Search in live Grep";
    };

    # Vim Pickers
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#vim-pickers
    "<leader>fo" = {
      action = "oldfiles";
      options.desc = "Find previously Opened file";
    };
    "<leader>fl" = {
      action = "current_buffer_fuzzy_find";
      options.desc = "Search Locally";
    };
    "<leader>f." = {
      action = "resume initial_mode=normal";
      options.desc = "Resume";
    };

    # Vim Pickers for Settings-like Entities
    "<leader>fh" = {
      action = "help_tags theme=ivy";
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
    "<leader>fr" = {
      action = "registers theme=ivy";
      options.desc = "Find in vim Registers";
      mode = mapToModeAbbr [
        "normal"
        "visual_select"
      ];
    };
    "<leader>fR" = {
      action = "reloader";
      options.desc = "Find modules to Reload";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>fl";
      action = "\"ly:Telescope current_buffer_fuzzy_find default_text=<C-r>l<CR>";
      mode = mapToModeAbbr [
        "visual_select"
      ];
      options.desc = "Search Locally";
    }
  ];
}
