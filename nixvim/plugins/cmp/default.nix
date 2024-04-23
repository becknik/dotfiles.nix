{ ... }:

{
  extraConfigLuaPre = (builtins.readFile ./cmp.lua)
    + ''

    local lsnip = require('luasnip')
  '';

  # https://github.com/hrsh7th/nvim-cmp
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings = {
      experimental.ghost_text = true;
      performance.max_view_entries = 50;

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

      snippet.expand = ''function(args) require('luasnip').lsp_expand(args.body) end'';

      # https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
      # https://github.com/nix-community/nixvim/blob/ad6a08b69528fdaf7e12c90da06f9a34f32d7ea6/plugins/completion/cmp/cmp-helpers.nix#L23-L67
      sources = [
        # cmp recommendations
        { name = "nvim_lsp"; priority = 1000; }
        # { name = "nvim_lsp_signature_help"; priority = 1000; }
        { name = "luasnip"; priority = 900; }
        { name = "spell"; priority = 850; }
        { name = "path"; priority = 700; }
        { name = "buffer"; priority = 600; keyword_length = 3; }
        { name = "git"; priority = 500; }
        { name = "calc"; priority = 400; }
        { name = "dotenv"; priority = 300; }
        { name = "emoji"; priority = 100; }

        # TODO https://github.com/zbirenbaum/copilot-cmp
        # { name = "copilot"; group_index = 2; priority = 1000; } # TODO disable suggestion, panel module, as it can interfere with completions
        # { name = "rg"; group_index = 2; priority = 750; }
        # { name = "treesitter"; group_index = 2; priority = 750; }
        # { name = "yanky"; group_index = 1; priority = 750; } # TODO
        # { name = "async_path"; group_index = 1; priority = 500; }
        # { name = "vim_lsp"; group_index = 1; priority = 250; } # TODO what does vim-lsp even contain?

        # { name = "digraphs"; group_index = 3; } # https://vimhelp.org/digraph.txt.html

        # { name = "tags"; priority = 10; }

        # { name = "latex_symbols"; } / cmp-vimtex?
      ];

      window = {
        completion.border = "solid";
        documentation.border = "solid";
      };

      mapping = {
        # "<tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif lsnip.locally_jumpable(1) then
              lsnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        # "<s-tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<s-tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif lsnip.locally_jumpable(-1) then
              lsnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';


        "<c-j>" = "cmp.mapping.select_next_item()";
        "<c-k>" = "cmp.mapping.select_prev_item()";
        # TODO double mappings might be a bad idea
        "<c-p>" = "cmp.mapping.select_prev_item()";
        "<c-n>" = "cmp.mapping.select_next_item()";
        "<c-e>" = "cmp.mapping.abort()";

        "<c-u>" = "cmp.mapping.scroll_docs(-4)";
        "<c-d>" = "cmp.mapping.scroll_docs(4)";

        "<c-Space>" = "cmp.mapping.complete()";
        "<s-Space>" = "cmp.mapping.complete()";

        # "<cr>" = "cmp.mapping.confirm({ select = true })";
        "<cr>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              if lsnip.expandable() then
                lsnip.expand()
              else
                cmp.confirm { select = true }
              end
            else
              fallback()
            end
          end)
        '';
        "<s-cr>" = ''
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
      lua.sources = [
        { name = "nvim_lua"; } # neovim's lua api
      ];
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
