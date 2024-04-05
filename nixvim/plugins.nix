{ ... }:

{
  plugins = {
    cmp = {
      enable = true;

      settings = {
        performance.fetchingTimeout = 200;
        experimental = { ghost_text = true; };

        autoEnableSources = true;
        # Use `plugins.cmp.settings.snippet.expand` option. But watch out, you can no longer put only the name of the snippet engine.
        # If you use `luasnip` for instance, set:
        # ```
        # plugins.cmp.settings.snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end"
        snippet = { expand = "luasnip"; };

        formatting = {
          fields = [ "kind" "abbr" "menu" ];
        };

        # Use `plugins.cmp.settings.sources` option. But watch out, you can no longer provide a list of lists of sources.
        # For this type of use, directly write lua.
        # See the option documentation for more details.
        sources = [
          { name = "nvim_lsp"; }
          { name = "emoji"; }
          {
            name = "buffer"; # text within current buffer
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path"; # file system paths
            keywordLength = 3;
          }
          {
            name = "luasnip"; # snippets
            keywordLength = 3;
          }
        ];

        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = { border = "rounded"; };
        };

        mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
      };
    };

    lsp.servers = { lua-ls.enable = true; };
    cmp-emoji.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true; # file system paths
    cmp_luasnip.enable = true;
    cmp-cmdline.enable = false; # autocomplete for cmdline

    treesitter = {
      enable = true;
      indent = true;
      folding = true;
      nixvimInjections = true;
    };
    treesitter-context.enable = true;
    treesitter-textobjects.enable = true;

    luasnip.enable = true;

    nix.enable = true;
    nix-develop.enable = true;

    telescope.enable = true;
    todo-comments.enable = true;
    gitsigns.enable = true;

    lualine.enable = true;
    # transparent.enable = false; # TODO first need terminal support for this

    obsidian.enable = true;

  };
}
