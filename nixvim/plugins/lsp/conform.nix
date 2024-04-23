{ withDefaultKeymapOptions, pkgs, ... }:

{
  extraPackages = with pkgs; [
    codespell
    jq
    yamllint # FIXME "no config found" - not detected by conform.nvim
    yamlfmt
    # FIXME markdownfmt is missing
    markdownlint-cli # markdownlint-cli2
    nixpkgs-fmt # FIXME "no config found" - not detected by conform.nvim
    sqlfluff
    stylua
    shellcheck # shellchek-minimal
    shfmt
    isort
    black
    prettierd
    google-java-format
    rustfmt
  ] ++ (with pkgs.nodePackages_latest; [
    fixjson
  ]);

  # https://github.com/stevearc/conform.nvim
  plugins.conform-nvim = {
    enable = true;

    logLevel = "warn";
    # TODO auto-formatting on git hunks only?

    # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
    # TODO not installed (see https://github.com/nix-community/nixvim/issues/1141)
    formattersByFt =
      let prettier = [ [ "prettierd" /* "prettier" */ ] ];
      in
      {
        "*" = [ "codespell" ];
        "_" = [ "trim_whitespace" ];

        html = prettier;
        css = prettier; # stylelint?
        json = [ "fixjson" "jq" ]; # TODO is this even necessary due to ls?
        yaml = [ "yamllint" "yamlfmt" ]; # TODO is this even necessary due to ls?
        markdown = [ "markdownlint" "markdownfmt" ]; # TODO is this even necessary due to ls?

        # bibtex-tidy
        nix = [ "nixpkgs-fmt" ];
        sql = [ "sqlfluff" ]; # "sql_formatter" "sqlfmt" # TODO is this even necessary due to ls?

        lua = [ "stylua" ]; # TODO is this even necessary due to ls?
        bash = [ "shellcheck" "shfmt" ]; # beautysh # TODO is this even necessary due to ls?
        python = [ "isort" "black" ]; # use darker instead of back? autopep8 # TODO is this even necessary due to ls?
        javascript = prettier;
        javascriptreact = prettier;
        typescript = prettier;
        typescriptreact = prettier;

        java = [ "google-java-format" ]; # TODO is this even necessary due to ls?
        rust = [ "rustfmt" ]; # TODO is this even necessary due to ls?
        # cabal_fmt
      };
    # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#customizing-formatters
    formatters = {
      # https://github.com/stevearc/conform.nvim/blob/master/doc/formatter_options.md#injected
      # TODO does injected conform linting work?
      injected.options = {
        lang_to_ext = {
          markdown = "md";

          latex = "tex";

          bash = "sh";
          python = "py";
          ruby = "rb";
          javascript = "js";
          typescript = "ts";

          rust = "rs";
        };
      };
      rustfmt.options = {
        default_edition = "2021";
      };
    };
  };

  extraConfigLuaPost = ''
    -- credits: https://github.com/stevearc/conform.nvim/issues/92#issuecomment-2069915330
    vim.api.nvim_create_user_command('FormatHunks', function()
      local hunks = require("gitsigns").get_hunks()
      local format = require("conform").format
      for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk ~= nil and hunk.type ~= "delete" then
          local start = hunk.added.start
          local last = start + hunk.added.count
          -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
          local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
          local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
          format({ range = range, async = true, lsp_fallback = true, })
        end
      end
    end, {})

    vim.api.nvim_create_user_command("ConformFormat", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ lsp_fallback = true, range = range })
    end, { range = true })
  '';

  keymaps = withDefaultKeymapOptions [
    { key = "<leader>H"; action = "<cmd>FormatHunks<cr>"; }
  ];
}
