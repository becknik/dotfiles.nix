{ withDefaultKeymapOptions, ... }:

{
  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>d", icon = " ", desc = "Diagnostic"  },

      { "<leader>dl", icon = " 󰘤 " },
      { "<leader>dp", icon = "  " },
      { "<leader>dn", icon = "  " },
      { "<leader>dP", icon = "  " },
      { "<leader>dN", icon = "  " },
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
      action.__raw = ''
        function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options.desc = "Next Diagnostic Error";
    }
    {
      key = "<leader>dp";
      action.__raw = ''
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options.desc = "Previous Diagnostic Error";
    }
    {
      key = "<leader>dN";
      action = "Lspsaga diagnostic_jump_next";
      options.cmd = true;
      options.desc = "Next Diagnostic";
    }
    {
      key = "<leader>dP";
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
