{ pkgs, ... }:

{
  imports = [
    ./keybindings.nix
  ];

  extraConfigLuaPre = (builtins.readFile ./cmp.lua); # sets neovim kinds to (nerdfont) symbols

  extraPlugins = [{
    plugin = with pkgs; (vimUtils.buildVimPlugin {
      name = "cmp-dotenv";
      src = fetchFromGitHub {
        owner = "SergioRibera";
        repo = "cmp-dotenv";
        rev = "7af67e7ed4fd9e5b20127a624d22452fbd505ccd";
        hash = "sha256-/aQlOE92LPSSv+X968MDw8Mb1Yy4SeqS5xVb4PTBbcw=";
      };
    });
  }];

  # https://github.com/hrsh7th/nvim-cmp
  plugins = {
    cmp-git = {
      settings.filetypes = [ "*" ];
      enable = true;
    };
    # cmp-conventionalcommits.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        experimental.ghost_text = true;
        performance.max_view_entries = 200;

        formatting = {
          fields = [ "menu" "kind" "abbr" ];
          # makes use of contents in ./cmp.lua
          format = ''
            function(entry, vim_item)
              if symbols[vim_item.kind] == nill then
                vim_item.kind = vim_item.kind
              else
                vim_item.kind = symbols[vim_item.kind]
                -- vim_item.kind = string.format('%s %s', symbols[vim_item.kind], vim_item.kind)
              end 
              vim_item.menu = ({
                buffer = "[]",
                nvim_lsp = "[]",
                luasnip = "[󰌒]",
                nvim_lua = "[]",
                look = "[]",
                dotenv = "[e]",
                spell = "[󰓆]",
                async_path = "[]",
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
          { name = "nvim_lua"; priority = 1000; } # neovim's lua api; only loaded in .lua files
          { name = "nvim_lsp"; priority = 950; }
          { name = "luasnip"; priority = 900; }
          # { name = "nvim_lsp_signature_help"; priority = 1000; }
          { name = "buffer"; priority = 800; }

          { name = "spell"; priority = 700; options = { keep_all_entries = true; }; }
          {
            name = "look";
            priority = 600;
            keyword_length = 3;
            options = { convert_case = true; loud = true; dict = "${pkgs.scowl}/share/dict/words.txt"; };
          }
          # https://github.com/SergioRibera/cmp-dotenv
          { name = "dotenv"; priority = 500; }
          # spell is rather useful as code-action than recommendation

          # triggered by prefixes
          { name = "async_path"; }
          { name = "calc"; }
          { name = "emoji"; priority = 1000; } # show emoji before git commits on : suffix
          { name = "git"; priority = 975; } # higher prio than lsp

          # TODO https://github.com/zbirenbaum/copilot-cmp
          # { name = "copilot"; group_index = 2; priority = 1000; } # TODO disable suggestion, panel module, as it can interfere with completions

          # { name = "rg"; group_index = 2; priority = 750; }
          # { name = "treesitter"; group_index = 2; priority = 750; }
          # { name = "yanky"; group_index = 1; priority = 750; } # TODO

          # { name = "digraphs"; group_index = 3; } # https://vimhelp.org/digraph.txt.html

          # { name = "tags"; priority = 10; }

          # { name = "latex_symbols"; } / cmp-vimtex?
        ];

        window = {
          completion.border = "solid";
          documentation.border = "solid";
        };
      };

      # copy-pasta from here: https://github.com/hrsh7th/nvim-cmp/?tab=readme-ov-file#recommended-configuration
      cmdline =
        let mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
        in {
          "/" = {
            inherit mapping;
            sources = [
              { name = "buffer"; }
              { name = "async_path"; }
              # https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol
              # { name = "nvim_lsp_document_symbol"; priority = 500; } # don't know if really useful...
            ];
          };
          ":" = {
            inherit mapping;
            sources = [
              { name = "async_path"; }
              {
                name = "cmdline";
                option = { ignore_cmds = [ "Man" "!" ]; };
              }
              { name = "cmp-cmdline-history"; }
            ];
          };
        };

      filetype =
        let
          dap = [{ name = "dap"; }];
          gitSources = [
            { name = "git"; }
            # { name = "conventionalcommits"; } # requires https://commitlint.js.org/#/
            # isn't working so far...
          ];
        in
        {
          # this might not be enough to enable the dap-cmp: https://github.com/rcarriga/cmp-dap
          dap-repl.sources = dap;
          dapui_watches.sources = dap;
          dapui_hover.sources = dap;

          gitcommit.sources = gitSources;
          NeogitCommitMessage.sources = gitSources;
        };
    };
  };
}
