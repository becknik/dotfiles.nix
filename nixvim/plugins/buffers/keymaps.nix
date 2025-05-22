{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<C-s>", icon = " 󱡄 " },
      { "<leader>s", icon = " " },
      { "<leader>q", icon = " " },
      { "<leader>Q", icon = " !" },
      { "<leader>w", icon = " " },

      { "<leader>bf", icon = "  " },
    }
  '';

  plugins.telescope.keymaps = {
    "<leader>bf" = {
      action = "buffers";
      options.desc = "Find Buffer";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>q";
      action = "Bdelete";
      options.cmd = true;
      options.desc = "Quit Buffer";
    }
    {
      key = "<leader>Q";
      action = "Bdelete!";
      options.cmd = true;
      options.desc = "Force Quit Buffer";
    }

    {
      key = "<C-s>";
      action = "ConformFormatHunks";
      mode = mapToModeAbbr [
        "normal"
        "insert"
      ];
      options.cmd = true;
      options.desc = "Write Buffer after Formatting Hunks";
    }
    {
      key = "<leader>s";
      action = "write";
      options.cmd = true;
      options.desc = "Write Buffer";
    }

    {
      key = "<leader>w";
      action.__raw = "function() vim.api.nvim_win_close(0, false) end";
      options.desc = "Quit Window";
    }
    {
      key = "<leader>r";
      action = "edit";
      options.cmd = true;
      options.desc = "Reload Buffer from  Disk";
    }
  ];
}
