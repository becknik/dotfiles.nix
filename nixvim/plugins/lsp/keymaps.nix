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
      { "gH", icon = "󰧮  " },

      { "<leader>o", icon = " " }, -- 󱉯

      { "<leader>c", desc = "Code etc." },

      { "<leader>fy", icon = "  " },
      { "<leader>fY", icon = "  " },
    }
  '';

  plugins.telescope.keymaps = {
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#neovim-lsp-pickers
    "<leader>fy" = {
      action = "lsp_document_symbols";
      options.desc = "Find local Symbols";
    };
    "<leader>fY" = {
      action = "lsp_workspace_symbols"; # lsp_dynamic_workspace_symbols
      options.desc = "Find global Symbols";
    };
  };

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
        action.__raw = "function() require'lspsaga.symbol'.outline { layout = 'float' } end";
        options.desc = "Outline (float)";
      }

      {
        key = "<leader>r";
        action = "Lspsaga rename";
        options.cmd = true;
        options.desc = "Rename";
      }
    ];
  };
}
