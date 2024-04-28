{ pkgs, ... }:

{
  extraConfigLuaPre = (builtins.readFile ./cmp.lua)
    + ''

    local lsnip = require('luasnip')
    require('cmp_git').setup()
  '';

  # https://github.com/petertriho/cmp-git?tab=readme-ov-file#config

  # TODO doesn't work
  extraPackages = with pkgs; [
    curl
    git
    gh
    glab
    vimPlugins.cmp-git

    (vimUtils.buildVimPlugin {
      name = "cmp-dotenv";
      src = fetchFromGitHub {
        owner = "SergioRibera";
        repo = "cmp-dotenv";
        rev = "7af67e7ed4fd9e5b20127a624d22452fbd505ccd";
        hash = "sha256-/aQlOE92LPSSv+X968MDw8Mb1Yy4SeqS5xVb4PTBbcw=";
      };
    })
  ];

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
            if symbols[vim_item.kind] == nill then
              vim_item.kind = vim_item.kind
            else
              vim_item.kind = string.format('%s %s', symbols[vim_item.kind], vim_item.kind)
            end
            vim_item.menu = ({
              buffer = "[Buf]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[]",
              look = "[Look]",
              dotenv = "[Env]",
              spell = "[Spell]",
              path = "[Path]",
              git = "[]",
              calc = "[󱖦]",
              emoji = "[󰞅]",
            })[entry.source.name]
            return vim_item
          end
        '';
      };

      view.entries = {
        name = "custom";
        selection_order = "near_cursor";
      };

      sorting = {
        comparators = [
          "require('cmp.config.compare').offset"
          "require('cmp.config.compare').exact"
          "require('cmp.config.compare').score"
          "require('cmp.config.compare').locality"
          "require('cmp.config.compare').recently_used"
          "require('cmp.config.compare').kind"
        ];
      };

      # performance = { fetchingTimeout = 200; maxViewEntries = 50; };

      snippet.expand = ''function(args) require('luasnip').lsp_expand(args.body) end'';

      # https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
      # https://github.com/nix-community/nixvim/blob/ad6a08b69528fdaf7e12c90da06f9a34f32d7ea6/plugins/completion/cmp/cmp-helpers.nix#L23-L67
      sources = [
        { name = "luasnip"; priority = 1000; }
        { name = "nvim_lsp"; priority = 900; }
        # { name = "nvim_lsp_signature_help"; priority = 1000; }
        {
          name = "buffer";
          priority = 800;
          keyword_length = 3;
          options = { get_buffnr = "function() return vim.api.nvim_list_bufs() end"; };
        }
        {
          name = "look";
          priority = 700;
          keyword_length = 3;
          options = { convert_case = true; loud = true; dict = "${pkgs.scowl}/share/dict/words.txt"; };
        }
        # https://github.com/SergioRibera/cmp-dotenv
        { name = "dotenv"; priority = 500; }
        # spell is rather useful as code-action than recommendation
        { name = "spell"; priority = 400; options = { keep_all_entries = true; }; }
        { name = "nvim_lua"; priority = 300; } # neovim's lua api (when loading as filetype, the other sources are excluded...)

        # no priority due to prefix triggers
        { name = "path"; }
        { name = "git"; }
        { name = "calc"; }
        { name = "emoji"; }

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
              cmp.confirm { select = true }
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
            if lsnip.locally_jumpable(-1) then
              lsnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';


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
      gitcommit.sources = [
        { name = "git"; }
        { name = "conventionalcommits"; } # TODO requires https://commitlint.js.org/#/
      ];
      # this might not be enough to enable the dap-cmp: https://github.com/rcarriga/cmp-dap
      dap-repl.sources = dap;
      dapui_watches.sources = dap;
      dapui_hover.sources = dap;
    };
  };
}
