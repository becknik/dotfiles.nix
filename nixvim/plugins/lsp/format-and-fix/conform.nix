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
                  vim.notify("Failed formatting: " .. err, "error", { title = "Conform All" })
                elseif (did_edit) then
                  vim.notify("Done formatting", "info", { title = "Conform All", render = "compact" })
                  vim.cmd("silent noautocmd write")
                  vim.cmd('silent GuessIndent')
                else
                  vim.notify("Nothing to format", "info", { title = "Conform All", render = "compact" })
                  vim.cmd("silent noautocmd write")
                end
              end
            )

            if not range then
              -- This blocks the buffer for a annoyingly long time, so disable it for now & waiting for
              -- https://github.com/neovim/neovim/issues/19624 to eventually resolve
              -- vim.lsp.buf.code_action {
              --   context = { only = { "source.organizeImports" } },
              --   apply = true,
              -- }
            end
          end
        '';
    };

    ConformFormatHunks = {
      command.__raw = ''
        function(args)
          local bufnr = args.buf or vim.api.nvim_get_current_buf()

          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            vim.api.nvim_command("noautocmd write")
            return
          end
          if vim.b[bufnr].disable_hunk_fmt or vim.g.disable_hunk_fmt then
            vim.api.nvim_command("ConformFormat")
            return
          end

          local format_start = vim.loop.hrtime() / 1e6 -- ms

          local hunks = require("gitsigns").get_hunks(bufnr)
          if not hunks then
            vim.notify("No hunks available", "info", { title = "Conform Hunks" })
            vim.b.disable_hunk_fmt = true
            vim.api.nvim_command("ConformFormat")
            return
          end

          local fidget = require("fidget")
          fidget.notify(
            "Starting to format hunks...",
            2,
            {
              key = "conform_format_hunk",
              annote = "Conform Hunks",
              skip_history = true,
            }
          )

          local hunks_amount = #hunks
          local hunks_processing = 0
          local executed_writes = 0

          local fidget = require("fidget")
          local function update_status(processing, amount, writes, completed_time)
            fidget.notify(
              (completed_time and math.floor((completed_time / 1e6) - format_start) .. "ms Completed formatting " or  "Formatting ")
              .. processing .. "/" .. amount .. " (" .. writes .. ") hunks",
              2,
              {
                key = "conform_format_hunk",
                annote = "Conform Hunks",
                skip_history = true,
                update_only = true,
              }
            )
          end

          local function format_range()
            if next(hunks) == nil then
              update_status(hunks_processing, hunks_amount, executed_writes, vim.loop.hrtime())
              vim.schedule(function()
                vim.api.nvim_command("noautocmd write")
                -- vim.lsp.buf.code_action {
                --   context = { only = { "source.organizeImports" } },
                --   apply = true,
                -- }
              end)
              return
            end

            local hunk = nil
            while next(hunks) and (not hunk or hunk.type == "delete") do
              hunk = table.remove(hunks)
              hunks_processing = hunks_processing + 1
              update_status(hunks_processing, hunks_amount, executed_writes, false)
            end

            if not hunk then
              return format_range()
            end

            -- TODO hypothesis: some formatters (like prettier) need at least 1 non-blank context line
            local start = hunk.added.start
            local last = start + hunk.added.count
            -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
            local last_hunk_line = vim.api.nvim_buf_get_lines(bufnr, last - 2, last - 1, true)[1]
            local range = {
              start = { start, 0 },
              ["end"] = { last - 1, last_hunk_line:len() }
            }

            require("conform").format({
              bufnr = bufnr,
              range = range,
              async = true,
              -- quiet   = true,
            }, function(err, did_edit)
              if err then
                vim.notify("Failed formatting: " .. err, "error", { title = "Conform Hunks" })
                return;
              end

              local now = vim.loop.hrtime() / 1e6 -- ms
              if now - format_start > 2000 and not vim.b[bufnr].disable_hunk_fmt then
                vim.b[bufnr].disable_hunk_fmt = true
                vim.notify("Formatting hunks took too longer than 2s", "warn", { title = "Conform Hunks" })
                vim.notify(
                  "Locally hunk-formatting disabled",
                  "info",
                  { title = "Conform" }
                )
                if #hunks > hunks_processing / 2 then 
                  -- immediately format the rest if it takes around 3s
                  vim.api.nvim_command("ConformFormat")
                  return
                end
              end

              if did_edit then
                -- not thread-save, but who cares =)
                executed_writes = executed_writes + 1
                update_status(hunks_processing, hunks_amount, executed_writes, false)
              end
              format_range()
            end)
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
      key = "<leader>tF";
      action.__raw = ''
        function() 
          local prev = vim.g.disable_autoformat or false
          vim.g.disable_autoformat = not prev
          vim.notify(
            "Global auto-formatting " .. (prev and  "enabled" or "disabled"),
            "info",
            { title = "Conform" }
          )
        end
      '';
      options.desc = "Toggle Auto-Format Global";
    }
    {
      key = "<leader>tf";
      action.__raw = ''
        function()
          local prev = vim.b.disable_autoformat or false
          vim.b.disable_autoformat = not prev
          vim.notify(
            "Local auto-formatting " .. (prev and  "enabled" or "disabled"),
            "info",
            { title = "Conform" }
          )
        end
      '';
      options.desc = "Toggle Auto-Format Local";
    }
    {
      key = "<leader>tU";
      action.__raw = ''
        function()
          local prev = vim.g.disable_hunk_fmt or false
          vim.g.disable_hunk_fmt = not prev
          -- NOTE: keep in sync with unification in ConformFormatHunks
          vim.notify(
            "Global hunk-formatting " .. (prev and "enabled" or "disabled" ),
            "info",
            { title = "Conform" }
          )
        end
      '';
      options.desc = "Toggle Auto-Format Global";
    }
    {
      key = "<leader>tu";
      action.__raw = ''
        function()
          local prev = vim.b.disable_hunk_fmt or false
          vim.b.disable_hunk_fmt = not prev
          -- NOTE: keep in sync with unification in ConformFormatHunks
          vim.notify(
            "Local hunk-formatting " .. (prev and "enabled" or "disabled" ),
            "info",
            { title = "Conform" }
          )
        end
      '';
      options.desc = "Toggle Hunk-Format Local";
    }

  ];

  plugins.conform-nvim.luaConfig.pre = ''
    wk.add {
      { "<leader>F", icon = "󱡄 " },
      { "<leader>tf", icon = " 󱡄 " },
      { "<leader>tF", icon = " 󱡄 " },
      { "<leader>tu", icon = "  󱡄 " },
      { "<leader>tU", icon = "  󱡄 " },
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
