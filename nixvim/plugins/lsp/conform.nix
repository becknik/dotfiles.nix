{ ... }:

{
  # https://github.com/stevearc/conform.nvim
  plugins.conform-nvim = {
    enable = true;

    logLevel = "warn";
    # TODO auto-formatting on git hunks only?
    formatOnSave = ''
      function()
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end
    '';

    # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
    # TODO not installed (see https://github.com/nix-community/nixvim/issues/1141)
    formattersByFt =
      let prettier = [ [ "prettierd" "prettier" ] ];
      in
      {
        "*" = [ "codespell" ];
        "_" = [ "trim_whitespace" ];

        html = prettier;
        css = prettier; # stylelint?
        json = [ "fixjson" "jq" ]; # TODO is this even necessary due to ls?
        yaml = [ "yamllint" "yamlfmt" ]; # TODO is this even necessary due to ls?
        markdown = [ "markdownlint" "markdownfmt" "markdown-toc" ]; # TODO is this even necessary due to ls?

        # bibtex-tidy
        nix = [ "nixpkgs-fmt" ];
        sql = [ "sqlfmt" ]; # sqlfluff # TODO is this even necessary due to ls?

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
}
