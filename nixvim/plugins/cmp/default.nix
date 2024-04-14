{ ... }:

{
  extraConfigLuaPre = builtins.readFile ./cmp.lua;

  # https://github.com/hrsh7th/nvim-cmp
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings = {
      experimental = { ghost_text = true; };

      completion = { keywordLength = 2; };

      formatting = {
        fields = [ "kind" "abbr" "menu" ];
        # makes use of contents of ./cmp.lua
        format = ''
          function(entry, vim_item)
            vim_item.kind = symbols[vim_item.kind]
            vim_item.menu = '[' .. entry.source.name .. ']'
            return vim_item
          end
        '';
      };

      # performance = { fetchingTimeout = 200; maxViewEntries = 50; };

      snippet = { expand = "luasnip"; };

      # https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
      # https://github.com/nix-community/nixvim/blob/ad6a08b69528fdaf7e12c90da06f9a34f32d7ea6/plugins/completion/cmp/cmp-helpers.nix#L23-L67
      sources = [
        # cmp recommendations
        { name = "nvim_lsp"; group_index = 1; priority = 1000; }
        { name = "nvim_lsp_signature_help"; group_index = 1; priority = 1000; }
        { name = "luasnip"; group_index = 1; priority = 1000; }

        { name = "spell"; group_index = 1; priority = 750; }
        # { name = "yanky"; group_index = 1; priority = 750; } # TODO
        { name = "path"; group_index = 1; priority = 500; }
        # { name = "async_path"; group_index = 1; priority = 500; }
        { name = "git"; group_index = 1; priority = 500; }
        { name = "buffer"; group_index = 1; priority = 250; }
        { name = "calc"; group_index = 1; priority = 250; }
        # { name = "vim_lsp"; group_index = 1; priority = 250; } # TODO what does vim-lsp even contain?

        # TODO https://github.com/zbirenbaum/copilot-cmp
        { name = "copilot"; group_index = 2; priority = 1000; } # TODO disable suggestion, panel module, as it can interfere with completions
        { name = "rg"; group_index = 2; priority = 750; }
        { name = "treesitter"; group_index = 2; priority = 750; }
        { name = "dotenv"; group_index = 2; priority = 500; }
        { name = "nvim_lua"; group_index = 2; priority = 250; } # neovim's lua api

        { name = "emoji"; group_index = 3; }
        # { name = "digraphs"; group_index = 3; } # https://vimhelp.org/digraph.txt.html

        # { name = "tags"; priority = 10; }

        # { name = "latex_symbols"; } / cmp-vimtex?
      ];

      window = {
        completion.border = "solid";
        documentation.border = "solid";
      };

      mapping = {
        # "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        # TODO somehow remove redundant "require(luasnip)"s
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require('luasnip').locally_jumpable(1) then
              require('luasnip').jump(1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        # "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require('luasnip').locally_jumpable(-1) then
              require('luasnip').jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';


        "<C-j>" = "cmp.mapping.select_next_item()";
        "<C-k>" = "cmp.mapping.select_prev_item()";
        # TODO double mappings might be a bad idea
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-e>" = "cmp.mapping.abort()";

        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";

        "<C-Space>" = "cmp.mapping.complete()";
        "<S-Space>" = "cmp.mapping.complete()";

        # "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<CR>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              if require('luasnip').expandable() then
                require('luasnip').expand()
              else
                cmp.confirm { select = true }
              end
            else
              fallback()
            end
          end)
        '';
        "<S-CR>" = ''
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }
        '';
      };
    };

    cmdline =
      let mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
      in {
        "/" = {
          inherit mapping;
          sources = [
            { name = "buffer"; }
            { name = "path"; }
            # https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol
            # { name = "nvim_lsp_document_symbol"; priority = 500; } # don't know if really useful...
          ];
        };
        ":" = {
          inherit mapping;
          sources = [
            { name = "path"; }
            {
              name = "cmdline";
              option = { ignore_cmds = [ "Man" "!" ]; };
            }
            { name = "cmp-cmdline-history"; }
          ];
        };
      };

    filetype = let dap = [{ name = "dap"; }]; in {
      gitcommit.sources = [
        { name = "git"; }
        {
          name = "conventionalcommits"; # TODO requires https://commitlint.js.org/#/
        }
      ];
      # this might not be enough to enable the dap-cmp: https://github.com/rcarriga/cmp-dap
      dap-repl.sources = dap;
      dapui_watches.sources = dap;
      dapui_hover.sources = dap;
    };
  };
}