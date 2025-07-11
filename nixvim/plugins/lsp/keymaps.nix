{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  #  
  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "gC", icon = " ", desc = "Function Calls" },
      { "gCi", icon = " " },
      { "gCI", icon = " " },

      { "gd", icon = "" },
      { "gD", icon = "", desc = "Declaration" },
      { "gp", icon = "󰹰 ", desc = "Preview" },
      { "gpt", icon = "󰹰  " },
      { "gpd", icon = "󰹰 " },

      { "g.", icon = "󱡄" },

      { "K", icon = "󰧮" },
      { "gh", icon = "󰧮  " },

      { "gy", icon = "󰌆 " },
      { "gY", icon = "󰌆 " },
      { "gs", icon = " ", desc = "Search" },
      { "gsr", icon = " " },
      { "gsd", icon = " " },
      { "gsi", icon = "  " },
      { "gst", icon = " " },

      { "<leader>c", desc = "Code etc.", icon = "󰲒 " }, -- 󰲒 󰢱
      { "<leader>ci", icon = "󰲒 󰋺 " },
      { "<leader>cm", icon = "󰲒 󰃹" },
      { "<leader>cu", icon = "󰲒 󰟼 " },
      { "<leader>cf", icon = "󰲒 󰁨 " },
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
    "gy" = {
      action = "lsp_document_symbols theme=ivy";
      options.desc = "Search in local Symbols";
    };
    "gY" = {
      action = "lsp_workspace_symbols theme=ivy"; # lsp_dynamic_workspace_symbols
      options.desc = "Search in global Symbols";
    };

    "gsr" = {
      action = "lsp_references theme=ivy initial_mode=normal";
      options.desc = "Search in ";
    };
    "gsd" = {
      action = "lsp_definitions theme=ivy initial_mode=normal";
      options.desc = "Search in ";
    };
    "gst" = {
      # is this really helpful?
      action = "lsp_type_definition theme=ivy initial_mode=normal";
      options.desc = "Search in Variablle Type Definitions";
    };
    "gsi" = {
      # -"-
      action = "lsp_implementations theme=ivy initial_mode=normal";
      options.desc = "Search in Implementations";
    };
  };

  plugins.lsp.keymaps = {
    lspBuf = {
      gD = "declaration";
      gd = "definition";
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
        key = "gpt";
        action = "Lspsaga peek_type_definition";
        options.cmd = true;
        options.desc = "Peek variable Type";
      }
      {
        key = "gpd";
        action = "Lspsaga peek_definition";
        options.cmd = true;
        options.desc = "Peek Definition";
      }

      {
        key = "K";
        action = "Lspsaga hover_doc";
        options.cmd = true;
        options.desc = "Hover Documentation";
      }
      {
        key = "gh";
        action = "Lspsaga hover_doc ++keep";
        options.cmd = true;
        options.desc = "Hover Documentation Keep";
      }

      {
        key = "gn";
        action = "Lspsaga rename";
        options.cmd = true;
        options.desc = "Rename";
      }

      # lsp-specific actions

      {
        key = "<leader>ci";
        action.__raw = ''
          function()
            vim.lsp.buf.code_action {
              context = { only = { "source.organizeImports" } },
              apply = true
            }
          end
        '';
        options.desc = "Organize Imports";
      }
      {
        key = "<leader>cm";
        action.__raw = ''
          function()
            vim.lsp.buf.code_action {
              context = { only = { "source.addMissingImports" } },
              apply = true
            }
          end
        '';
        options.desc = "Add Missing Imports";
      }
      {
        key = "<leader>cf";
        action.__raw = ''
          function()
            vim.lsp.buf.code_action {
              context = { only = { "source.fixAll" } },
              apply = true
            }
          end
        '';
        options.desc = "Fix All";
      }
      {
        key = "<leader>cu";
        action.__raw = ''
          function()
            vim.lsp.buf.code_action {
              context = { only = { "source.removeUnused" } },
              apply = true
            }
          end
        '';
        options.desc = "Remove Unused";
      }
    ];
  };
}
