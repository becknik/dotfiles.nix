{ defaultKeymapOptions, ... }:

{
  plugins.lsp.keymaps = {
    silent = false;

    # commented out ones are remapped in lspsaga.nix
    diagnostic = {
      # "<leader>p" = "goto_prev";
      # "<leader>n" = "goto_next";
      "<leader>e" = "open_float"; # TODO is this even doing something???
    };
    lspBuf = {
      # K = "hover";
      "<c-k>" = "signature_help";

      # gd = "definition";
      # gr = "references";
      gD = "declaration";
      # gi = "implementation";
      # gt = "type_definition";

      # TODO https://stackoverflow.com/questions/3519532/mapping-function-keys-in-vim ?
      # "<leader>rn" = "rename";
      # "<leader>ca" = "code_action";

      "<leader>wa" = "add_workspace_folder";
      "<leader>wr" = "remove_workspace_folder";
      # "<leader>wt" = "workspace_symbol"; # query symbols in workspace
      # use `wt` instead of `ws` to avoid typing both keys with the same finger
    };
    extra = builtins.map
      (binding: { options = defaultKeymapOptions; } // binding)
      [
        {
          key = "<leader>wl";
          action = "function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end";
          lua = true;
        }

        # Conform
        {
          key = "<leader>F";
          # action = "function() vim.lsp.buf.format {async = true} end";
          action = "function() require('conform').format { async = true, lsp_fallback = true } end";
          lua = true;
        }

        # LspSaga
        { key = "K"; action = "<cmd>Lspsaga hover_doc<cr>"; }

        # action = "<cmd>Lspsaga goto_definition<cr>";
        # action = "<cmd>Lspsaga peek_definition<cr>";
        { key = "gd"; action = "<cmd>Lspsaga finder def<cr>"; }
        { key = "gr"; action = "<cmd>Lspsaga finder ref<cr>"; }
        { key = "gi"; action = "<cmd>Lspsaga finder imp<cr>"; }
        { key = "gt"; action = "<cmd>Lspsaga peek_type_definition<cr>"; }
        # action = "<cmd>Lspsaga finder type_definition<cr>";

        { key = "<leader>o"; action = "<cmd>Lspsaga outline<cr>"; }
        # action = "<cmd>Lspsaga project_replace<cr>";
        { key = "<leader>rn"; action = "<cmd>Lspsaga rename<cr>"; }
        # action = "<cmd>Lspsaga project_replace<cr>";
        { key = "<leader>rN"; action = "<cmd>Lspsaga lsp_rename mode=n<cr>"; }
        { key = "<leader>ca"; action = "<cmd>Lspsaga code_action<cr>"; }
        # vim.keymap.set({'n','t', '<A-d>', '<cmd>Lspsaga term_toggle'})

        { key = "<leader>dn"; action = "<cmd>Lspsaga diagnostic_jump_next<cr>"; }
        { key = "<leader>dp"; action = "<cmd>Lspsaga diagnostic_jump_prev<cr>"; }
        { key = "<leader>dc"; action = "<cmd>Lspsaga show_cursor_diagnostics<cr>"; }
        { key = "<leader>dl"; action = "<cmd>Lspsaga show_line_diagnostics<cr>"; }
        { key = "<leader>db"; action = "<cmd>Lspsaga show_buf_diagnostics<cr>"; }
        { key = "<leader>dw"; action = "<cmd>Lspsaga show_workspace_diagnostics<cr>"; }
      ];
  };
}
