{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<C-s>", icon = " 󱡄 " },
      { "<leader>s", icon = " " },
      { "<leader>q", icon = " " },
      { "<leader>Q", icon = " !" },

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
      action = "write";
      mode = mapToModeAbbr [
        "normal"
        "insert"
      ];
      options.cmd = true;
      options.desc = "Write Buffer";
    }
  ];
}
