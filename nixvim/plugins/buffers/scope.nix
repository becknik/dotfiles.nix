{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  # https://github.com/tiagovla/scope.nvim
  plugins.scope = {
    enable = true;
  };

  plugins.scope.luaConfig.post = ''
    require'telescope'.load_extension'scope'
    wk.add {
      { "<leader>bt", icon = " 󰓩 " },
      { "<leader>bm", icon = "󰓩  " },
      { "<leader>bn", icon = "󰓩  " },
      { "<leader>bp", icon = "󰓩  " },
      { "<leader>bc", icon = "󰓩  " },
      { "<leader>bq", icon = "󰓩  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>bm";
      action = "ScopeMoveBuf";
      options.cmd = true;
      options.desc = "Move Buffer to Tab";
    }
    {
      key = "<leader>bt";
      action = "Telescope scope buffers";
      options.cmd = true;
      options.desc = "Find Buffers across Tabs";
    }

    {
      key = "<leader>bn";
      action = "tabnext";
      options.cmd = true;
      options.desc = "Next Tab";
    }
    {
      key = "<leader>bp";
      action = "tabprevious";
      options.cmd = true;
      options.desc = "Previous Tab";
    }
    {
      key = "<leader>bc";
      action = "tabnew";
      options.cmd = true;
      options.desc = "Create Tab";
    }
    {
      key = "<leader>bq";
      action = "tabclose";
      options.cmd = true;
      options.desc = "Quit Tab";
    }
  ];
}
