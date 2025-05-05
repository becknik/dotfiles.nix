{ withDefaultKeymapOptions, ... }:

{
  #  
  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "gc", icon = " ", desc = "Function Calls" },
      { "gci", icon = " " },
      { "gcI", icon = " " },

      { "gp", icon = "  ", desc = "Peek" },
      { "gt", icon = " " },
      { "gpt", icon = " " },
      { "gd", icon = " " },
      { "gpd", icon = " " },

      { "gr", icon = "" },

      { "gh", icon = "󰧮" },
      { "gH", icon = "󰧮 " },

      { "<leader>o", icon = " " }, -- 󱉯
      { "<leader>O", icon = " " },

      { "<leader>d", icon = " ", desc = "Diagnostic"  },
      { "<leader>dl", icon = " 󰘤 " },
      { "<leader>dp", icon = "  " },
      { "<leader>dn", icon = "  " },
    }
  '';

  plugins.lsp.keymaps = {
    lspBuf = {
      gD = "declaration";
    };

    extra = withDefaultKeymapOptions [
      {
        key = "<leader>ca";
        action = "Lspsaga code_action";
        options.cmd = true;
        options.desc = "Code Actions";
      }

      # Incomming/ Outgoing Definitions
      {
        key = "gci";
        action = "Lspsaga incoming_calls";
        options.cmd = true;
        options.desc = "Goto Calls Icomming";
      }
      {
        key = "gcI";
        action = "Lspsaga outgoing_calls";
        options.cmd = true;
        options.desc = "Goto Calls Outgoing";
      }

      # Type & Definition
      {
        key = "gt";
        action = "Lspsaga goto_type_definition";
        options.cmd = true;
        options.desc = "Variable Type";
      }
      {
        key = "gpt";
        action = "Lspsaga peek_type_definition";
        options.cmd = true;
        options.desc = "Peek variable Type";
      }
      {
        key = "gd";
        action = "Lspsaga goto_definition";
        options.cmd = true;
        options.desc = "Definition";
      }
      {
        key = "gpd";
        action = "Lspsaga peek_definition";
        options.cmd = true;
        options.desc = "Peek Definition";
      }

      {
        key = "gr";
        action = "Lspsaga finder ref";
        options.cmd = true;
        options.desc = "References";
      }
      {
        key = "gi";
        action = "Lspsaga finder imp";
        options.cmd = true;
        options.desc = "Implementations";
      }

      {
        key = "gh";
        action = "Lspsaga hover_doc";
        options.cmd = true;
        options.desc = "Hover Documentation";
      }
      {
        key = "gH";
        action = "Lspsaga hover_doc ++keep";
        options.cmd = true;
        options.desc = "Hover Documentation Keep";
      }

      {
        key = "<leader>o";
        action.__raw = "function() require'lspsaga.symbol'.outline { layout = 'normal' } end";
        options.desc = "Outline float";
      }
      {
        key = "<leader>O";
        # TODO outline in float mode doesn't work... - experiment with detail = false?
        action.__raw = "function() require'lspsaga.symbol'.outline { layout = 'float' } end";
        options.desc = "Outline fixed";
      }

      {
        key = "<leader>r";
        action = "Lspsaga rename";
        options.cmd = true;
        options.desc = "Rename";
      }

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
  };
}
