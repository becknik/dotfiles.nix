{ ... }:

{
  # https://github.com/neovim/nvim-lspconfig
  plugins.lsp = {
    enable = true;
    servers = {
      typos-lsp.enable = true; # Source code spell checker for Visual Studio Code

      html.enable = true;
      #templ.enable = true; # HTML
      lemminx.enable = true;
      jsonls.enable = true;
      marksman.enable = true;
      taplo.enable = true; # TOML
      yamlls.enable = true;

      dockerls.enable = true;


      lua-ls.enable = true;
      nil_ls.enable = true;
      # rnix-lsp.enable = true;
      sqls.enable = true;
      texlab.enable = true;

      bashls.enable = true;
      pyright.enable = true;

      eslint.enable = true;
      tsserver.enable = true;

      clangd.enable = true;
      rust-analyzer = {
        enable = true;
        installCargo = false; # TODO is working with rustup?
        installRustc = false;
      };
      hls.enable = true;
      # zls.enable = true;

      java-language-server.enable = true;
      kotlin-language-server.enable = true;
      # metals.enable = true;
    };

    keymaps = {
      silent = false;
      diagnostic = {
        "<leader>p" = "goto_next";
        "<leader>n" = "goto_prev";
        "<leader>e" = "open_float";
      };
      lspBuf = {
        K = "hover";
        "<C-k>" = "signature_help";

        gr = "references";
        gd = "definition";
        gD = "declaration";
        gi = "implementation";
        gt = "type_definition";

        # TODO https://stackoverflow.com/questions/3519532/mapping-function-keys-in-vim ?
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";

        "<leader>wa" = "add_workspace_folder";
        "<leader>wr" = "remove_workspace_folder";
        "<leader>ws" = "workspace_symbol"; # query symbols in workspace
      };
      extra = [
        {
          key = "<leader>wl";
          action = ''
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end
          '';
          lua = true;
        }
        {
          key = "<leader>f";
          action = ''
            function()
              vim.lsp.buf.format {async = true}
            end
          '';
          lua = true;
        }
      ];
    };
  };
}
