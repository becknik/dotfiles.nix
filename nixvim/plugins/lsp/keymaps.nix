{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  #  
  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "gC", icon = " ", desc = "Function Calls" },
      { "gCi", icon = " " },
      { "gCI", icon = " " },

      { "gp", icon = "  ", desc = "Peek" },
      { "gt", icon = " " },
      { "gd", icon = "" },
      { "gp", icon = "󰹰 ", desc = "Preview" },
      { "gpt", icon = "󰹰  " },
      { "gpd", icon = "󰹰 " },

      { "gr", icon = "" },
      { "gi", icon = " " },
      { "g.", icon = "󱡄" },

      { "gh", icon = "󰧮" },
      { "gH", icon = "󰧮  " },

      { "go", icon = " " }, -- 󱉯

      { "gs", icon = " ", desc = "Telescope" },
      { "gsy", icon = " 󰌆 " },
      { "gsY", icon = " 󰌆 " },
      { "gsr", icon = " " },
      { "gsd", icon = " " },
      { "gsi", icon = "  " },
      { "gst", icon = " " },
    }
  '';

  extraConfigLuaPre = ''
    for _, m in ipairs({
      { lhs = 'gri', mode = 'n' },
      { lhs = 'gra', mode = {'n','x'} },
      { lhs = 'grr', mode = 'n' },
      { lhs = 'grn', mode = 'n' },
      { lhs = '<C-S>', mode = 'i' },
    }) do
      vim.keymap.del(m.mode, m.lhs)
    end
  '';

  plugins.telescope.keymaps = {
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#neovim-lsp-pickers
    "gsy" = {
      action = "lsp_document_symbols";
      options.desc = "Search in local Symbols";
    };
    "gsY" = {
      action = "lsp_workspace_symbols"; # lsp_dynamic_workspace_symbols
      options.desc = "Search in global Symbols";
    };
    "gsr" = {
      action = "lsp_references";
      options.desc = "Search in ";
    };
    "gsd" = {
      action = "lsp_definitions";
      options.desc = "Search in ";
    };
    "gst" = {
      # is this really helpful?
      action = "lsp_type_definition";
      options.desc = "Search in Variablle Type Definitions";
    };
    "gsi" = {
      # -"-
      action = "lsp_implementations";
      options.desc = "Search in Implementations";
    };
  };

  plugins.lsp.keymaps = {
    lspBuf = {
      gD = "declaration";
    };

    extra = withDefaultKeymapOptions [
      {
        key = "g.";
        action = "Lspsaga code_action";
        mode = mapToModeAbbr [
          "normal"
          "visual_select"
        ];
        options.cmd = true;
        options.desc = "Code Actions";
      }

      # Incomming/ Outgoing Definitions
      {
        key = "gCi";
        action = "Lspsaga incoming_calls";
        options.cmd = true;
        options.desc = "Goto Calls Icomming";
      }
      {
        key = "gCI";
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
        key = "go";
        action.__raw = "function() require'lspsaga.symbol'.outline { layout = 'float' } end";
        options.desc = "Outline (float)";
      }

      {
        key = "gn";
        action = "Lspsaga rename";
        options.cmd = true;
        options.desc = "Rename";
      }
    ];
  };
}
