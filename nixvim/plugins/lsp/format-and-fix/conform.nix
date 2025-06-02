{
  lib,
  pkgs,
  withDefaultKeymapOptions,
  mapToModeAbbr,
  ...
}:

{
  # https://www.reddit.com/r/neovim/comments/16hpxwu/conformnvim_another_plugin_to_replace_nullls/
  userCommands = {
    ConformFormat = {
      range = true;
      # https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
      command.__raw = # lua
        ''
          function(args)
            local range = nil
            if args.count ~= -1 then
              local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
              range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
              }
            end
            require("conform").format({
              async = true,
              lsp_format = "fallback",
              range = range
            }, function(err, did_edit)
                if (err) then
                  vim.notify("Failed formatting: " .. err, "error", { title = "Conform" })
                elseif (did_edit) then
                  vim.notify("Done formatting", "info", { title = "Conform", render = "compact" })
                  vim.cmd("silent noautocmd write")
                  vim.cmd('silent GuessIndent')
                else
                  vim.notify("Nothing to format", "info", { title = "Conform", render = "compact" })
                  vim.cmd("silent noautocmd write")
                end
              end
            )
          end
        '';
    };

    ConformFormatHunks = {
      command.__raw = ''
        function(args)
          local bufnr = args.buf or vim.api.nvim_get_current_buf()

          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          local hunks = require("gitsigns").get_hunks(bufnr)
          if not hunks then
            vim.api.nvim_command("ConformFormat")
            return
          end

          local executed_writes = 0
          local function format_range()
            if next(hunks) == nil then
              if executed_writes > 0 then
                vim.notify("Formatted " .. executed_writes .." git hunks", "info", { title = "Conform Auto Format", render = "compact" })
              end

              vim.schedule(function() vim.api.nvim_command("noautocmd write") end)
              return
            end

            local hunk = nil
            while next(hunks) and (not hunk or hunk.type == "delete") do
                hunk = table.remove(hunks)
            end

            if hunk and hunk.type ~= "delete" then
              -- TODO hypothesis: some formatters (like prettier) need at least 1 non-blank context line
              local start = hunk.added.start
              local last = start + hunk.added.count
              -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
              local last_hunk_line = vim.api.nvim_buf_get_lines(bufnr, last - 2, last - 1, true)[1]
              local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }

              require("conform").format({
                bufnr = bufnr,
                range = range,
                async = true,
                -- quiet   = true,
              }, function(err, did_edit)
                if err then
                  vim.notify("Failed formatting: " .. err, "error", { title = "Conform Auto Format" })
                  return;
                end
                if did_edit then
                  -- not thread-save, but who cares =)
                  executed_writes = executed_writes + 1
                end

                vim.defer_fn(function()
                  format_range()
                end, 1)
              end)
            end
          end

          format_range()
        end
      '';
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>F";
      action = "ConformFormat";
      mode = mapToModeAbbr [
        "normal"
        "visual_select"
      ];
      options.cmd = true;
      options.desc = "Format";
    }

    {
      key = "<leader>tfg";
      action.__raw = "function() vim.g.disable_autoformat = true end";
      options.desc = "Toggle Format Global";
    }
    {
      key = "<leader>tfl";
      action.__raw = "function() vim.b.disable_autoformat = true end";
      options.desc = "Toggle Format Local";
    }

  ];

  plugins.conform-nvim.luaConfig.pre = ''
    wk.add {
      { "<leader>F", icon = "󱡄 " },
      { "<leader>tf", icon = " 󱡄 " },
    }
    local CONFORM_AUTOFORMAT_HUNKS_IGNORE = { 'lua' }
  '';

  # https://github.com/stevearc/conform.nvim
  plugins.conform-nvim = {
    enable = true;

    settings =
      let
        # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
        # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#customizing-formatters
        # most not installed by default (see https://github.com/nix-community/nixvim/issues/1141)
        formatterSetup = {
          # TODO do something about the default format configurations
          # https://github.com/google/yamlfmt/blob/main/docs/config-file.md#configuration-1
          # https://stylelint.io/user-guide/configure/
          typos.types = "*";
          typos.priority = 1;
          typos.command = lib.getExe pkgs.typos;
          trim_whitespace.types = "*";
          trim_newlines.types = "*";
          squeeze_blanks.types = "*";
          # commitmsgfmt

          markdownlint.types = "markdown"; # markdown-toc unnecessary
          markdownlint.command = lib.getExe pkgs.markdownlint-cli;

          # config files

          # relpace with yq?
          yamlfmt.types = "yaml";
          yamlfmt.command = lib.getExe pkgs.yamlfmt;
          taplo.types = "toml";

          ## json

          fixjson.types = [
            "json"
            "jsonc"
          ];
          fixjson.command = lib.getExe pkgs.nodePackages_latest.fixjson;

          # frontend

          html_beautify.types = "html";
          # html.command = lib.getExe pkgs.markdownlint-cli;

          stylelint.types = "css";
          stylelint.priority = -1;
          stylelint.command = lib.getExe pkgs.stylelint;
          css_beautify.types = "css";
          css_beautify.priority = -2;
          css_beautify.command = "${pkgs.nodePackages_latest.js-beautify}/bin/css-beautify";
          css_beautify.prepend_args = [
            "--type"
            "css"
            "--indent-size"
            "2"
          ];
          #, deno_fmt, docformatter

          # domain-specific languages

          sqlfluff.types = "sql";
          sqlfluff.command = lib.getExe pkgs.sqlfluff;
          # pg_format

          bibtex-tidy.types = "bibtex";
          bibtex-tidy.command = lib.getExe pkgs.bibtex-tidy;
          tex-fmt.types = "latex";
          tex-fmt.command = lib.getExe pkgs.tex-fmt;

          nixfmt.types = "nix";
          nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;

          shfmt.types = "bash";
          shfmt.command = lib.getExe pkgs.shfmt;
          # shellcheck.types = [ "bash"];
          # shellcheck.command = lib.getExe pkgs.shellcheck; # shellchek-minimal
          # shellharden.types = [ "bash"];
          # shellharden.command = lib.getExe pkgs.shellharden;

          # general purpose scripting

          stylua.types = "lua";
          stylua.command = lib.getExe pkgs.stylua;

          ruff_organize_imports.types = "python";
          ruff_organize_imports.command = lib.getExe pkgs.ruff;
          ruff_organize_imports.priority = 2;
          ruff_format.types = "python";
          ruff_format.command = lib.getExe pkgs.ruff;
          ruff_format.priority = 1;
          ruff_fix.types = "python";
          ruff_fix.command = lib.getExe pkgs.ruff;
          # isort.command = lib.getExe pkgs.isort;
          # black.command = lib.getExe pkgs.black;
          # hclfmt.command = lib.getExe pkgs.hclfmt;
          # alternatives: autopep8 darker (no package yet)

          ## js/ts

          eslint_d.types = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
          eslint_d.priority = 1; # take precedence over prettierd
          eslint_d.command = lib.getExe pkgs.eslint_d;
          prettierd.types = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
            "vue"
            "graphql"
            "css"
          ];
          prettierd.command = lib.getExe pkgs.prettierd;
          prettierd.priority = 0;

          # "heavy" programming languages

          goimports.types = "go";
          goimports.command = lib.getExe' pkgs.gotools "goimports";
          goimports.priority = 1;
          gofumpt.types = "go";
          gofumpt.command = lib.getExe pkgs.gofumpt;

          stylish-haskell.types = "haskell";
          stylish-haskell.command = lib.getExe pkgs.stylish-haskell;
          # ormolu, fourmolu, hindent
          cabal-fmt.types = "cabal";
          cabal-fmt.command = lib.getExe pkgs.haskellPackages.cabal-fmt;
          # hcl (what is this?)

          rustfmt.types = "rust";
          rustfmt.command = lib.getExe pkgs.rustfmt;

          clang_format.types = "cpp";
          gersemi.types = "cmake";
          gersemi.command = lib.getExe pkgs.gersemi;
        };
        names = builtins.attrNames formatterSetup;

        entries = builtins.concatLists (
          builtins.map (
            name:
            builtins.map
              (ft: {
                ft = ft;
                formatter = name;
              })
              (
                if builtins.isString formatterSetup.${name}.types then
                  [ formatterSetup.${name}.types ]
                else
                  formatterSetup.${name}.types
              )

          ) names
        );

        formatters = builtins.listToAttrs (
          builtins.map (name: {
            name = name;
            value = builtins.removeAttrs formatterSetup.${name} [
              "types"
              "priority"
            ];
          }) names
        );

        formatters_by_ft = builtins.foldl' (
          acc: entry:
          let
            ft = entry.ft;
            prev = acc.${ft} or [ ];
          in
          acc // { "${ft}" = prev ++ [ entry.formatter ]; }
        ) { } entries;

        formatters_by_ft_ordered = lib.mapAttrs (
          type: names:
          builtins.sort (
            a: b:
            let
              pa = formatterSetup.${a}.priority or 0;
              pb = formatterSetup.${b}.priority or 0;
            in
            if pa > pb then
              true
            else if pa < pb then
              false
            else
              a < b
          ) names
        ) formatters_by_ft;
      in
      {
        notify_on_error = true;
        log_level = "warn";

        default_format_opts = {
          lsp_format = "fallback";
          async = true;
        };

        formatters_by_ft = formatters_by_ft_ordered;
        formatters = formatters;
        # https://github.com/stevearc/conform.nvim/blob/master/doc/formatter_options.md#injected
        # TODO does injected conform linting work?
      };
  };
}
