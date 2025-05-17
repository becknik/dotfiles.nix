{ withDefaultKeymapOptions, ... }:

{
  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>d", icon = " ", desc = "Diagnostic"  },

      { "<leader>dl", icon = " 󰘤 " },
      { "<leader>dp", icon = "  " },
      { "<leader>dn", icon = "  " },
      { "<leader>df", icon = "  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>dl";
      action = "Lspsaga show_line_diagnostics";
      options.cmd = true;
      options.desc = "Line Diagnostic";
    }
    {
      key = "<leader>dn";
      action = "Lspsaga diagnostic_jump_next";
      options.cmd = true;
      options.desc = "Next Diagnostic";
    }
    {
      key = "<leader>dp";
      action = "Lspsaga diagnostic_jump_prev";
      options.cmd = true;
      options.desc = "Previous Diagnostic";
    }
  ];

  plugins.telescope.keymaps = {
    "<leader>df" = {
      action = "diagnostics";
      options.desc = "Find in local Diagnostics";
    };
  };
}
