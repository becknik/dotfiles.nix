{ ... }:

{
  # https://github.com/hrsh7th/nvim-cmp
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings = {
      experimental = { ghost_text = true; };

      completion = { keywordLength = 2; };

      formatting = { fields = [ "kind" "menu" "abbr" ]; };

      # performance = { fetchingTimeout = 200; maxViewEntries = 50; };

      snippet = { expand = "luasnip"; };

      # https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
      sources = [
        # cmp recommendations
        { name = "nvim_lsp"; group_index = 1; priority = 1000; }
        { name = "luasnip"; group_index = 1; priority = 1000; }
        { name = "buffer"; group_index = 1; priority = 250; }

        { name = "spell"; group_index = 1; priority = 750; }
        { name = "async-path"; group_index = 1; priority = 500; }
        { name = "git"; group_index = 1; priority = 500; }
        { name = "calc"; group_index = 1; priority = 250; }

        # TODO https://github.com/zbirenbaum/copilot-cmp
        { name = "copilot"; group_index = 2; priority = 1000; } # TODO disable suggestion, panel module, as it can interfere with completions
        { name = "dotenv"; group_index = 2; priority = 500; }
        { name = "nvim_lua"; group_index = 2; priority = 250; } # neovim's lua api

        { name = "emoji"; group_index = 3; }
        # { name = "digraphs"; group_index = 3; } # https://vimhelp.org/digraph.txt.html


        # { name = "treesitter"; priority = 30; }
        # { name = "tags"; priority = 10; }

        # { name = "latex_symbols"; } / cmp-vimtex?
      ];

      window = {
        completion.border = "solid";
        documentation.border = "solid";
      };

      mapping = {
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";

        "<C-j>" = "cmp.mapping.select_next_item()";
        "<C-k>" = "cmp.mapping.select_prev_item()";
        "<C-p>" = "cmp.mapping.select_next_item()";
        "<C-n>" = "cmp.mapping.select_prev_item()";
        "<C-e>" = "cmp.mapping.abort()";

        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";

        "<C-Space>" = "cmp.mapping.complete()";
        "<S-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
      };
    };

    cmdline =
      let mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
      in {
        "/" = {
          inherit mapping;
          sources = [{ name = "buffer"; }];
        };
        ":" = {
          inherit mapping;
          sources = [
            { name = "path"; }
            {
              name = "cmdline";
              option = { ignore_cmds = [ "Man" "!" ]; };
            }
          ];
        };
      };

    filetype = {
      gitcommit.sources = [{
        name = "conventionalcommits"; # TODO requires https://commitlint.js.org/#/
      }];
    };
  };
}
