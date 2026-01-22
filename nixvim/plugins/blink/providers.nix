{ pkgs, ... }:

{
  plugins.blink-cmp-git.enable = true;
  plugins.blink-cmp-spell.enable = true;
  plugins.blink-emoji.enable = true;

  plugins.blink-cmp.luaConfig.pre = ''
    local function is_in_string_like_node()
      if vim.bo.buftype == "prompt" then
        return false
      elseif vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype) then
        return true
      end

      local row, column = unpack(vim.api.nvim_win_get_cursor(0))
      -- get_node_at_cursor always seems to return the comment's parent node...
      local success, node = pcall(vim.treesitter.get_node, {
        bufnr = 0,
        pos = { row - 1, math.max(0, column - 1) } -- seems to be necessary...
      })

      local reject = {
        "comment",
        "comment_content",
        "line_comment",
        "block_comment",
        "string_start",
        "string_fragment",
        "string_content",
        "string_end"
      }

      -- vim.notify(vim.inspect({ success = success, node = node and node:type() }))
      return (success and node and vim.tbl_contains(reject, node:type()))
    end

    -- Deduplicate menu items. Source: https://github.com/Saghen/blink.cmp/issues/1222#issuecomment-2891921393
    local blink_list_show_original = require('blink.cmp.completion.list').show
    ---@diagnostic disable-next-line: duplicate-set-field
    require('blink.cmp.completion.list').show = function(ctx, items_by_source)
      local seen = {}
      -- ignore the characters that clangd adds to the start
      local function filter(item)
        if seen[item.label] then return false end
        seen[item.label] = true
        return true
      end
      for id in vim.iter({ "snippets" }) do -- only need to dedup luasnip
        items_by_source[id] = items_by_source[id] and vim.iter(items_by_source[id]):filter(filter):totable()
      end
      return blink_list_show_original(ctx, items_by_source)
    end
  '';

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "blink-cmp-luasnip-choice.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "becknik";
        repo = "blink-cmp-luasnip-choice";
        rev = "c99512e2be8bb96fa3a43ce4b4f581151ff3138e";
        hash = "sha256-tKT6Q3mJfhU+ApyWZQ12PJOcAAHHma+K+1Q3/VzxAXQ=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "cmp-tw2css.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "becknik";
        repo = "cmp-tw2css";
        rev = "a4c034d618418d0536f1d3f71881aea0b65b816c";
        hash = "sha256-c96i15h6eBEdhv7EE0xCYE4LiqleyPIG/LTjdggBlXY=";
      };
      nvimSkipModule = [
        "cmp-tw2css"
        "cmp-tw2css.items"
        "cmp-tw2css.generate"
      ];
    })
    pkgs.vimPlugins.blink-cmp-conventional-commits
  ];

  plugins.blink-compat.enable = true;
  plugins.blink-cmp.settings.sources = {
    default = [
      "lsp"
      "path"
      "buffer"
      "emoji"
      "git"
      "ecolog"
      "choice"
      "tw2css"
    ];
    per_filetype.__raw = ''
      {
        markdown = {
          inherit_defaults = true,
          "spell",
        },
        typst = {
          inherit_defaults = true,
          "spell",
        },
        codecompanion = {
          inherit_defaults = true,
          "spell",
        },
        gitcommit = {
          inherit_defaults = true,
          "spell",
        },
      }
    '';

    providers = {
      lsp.fallbacks = [
        "buffer"
        "emoji"
      ];
      git = {
        # https://github.com/Kaiser-Yang/blink-cmp-git
        module = "blink-cmp-git";
        name = "git";
        should_show_items.__raw = "is_in_string_like_node";
        min_keyword_length = 7;
      };
      emoji = {
        # https://github.com/moyiz/blink-emoji.nvim
        module = "blink-emoji";
        name = "emoji";
        score_offset = 100;
        should_show_items.__raw = "is_in_string_like_node";
      };
      spell = {
        # https://github.com/ribru17/blink-cmp-spell
        module = "blink-cmp-spell";
        name = "spell";
      };
      choice = {
        name = "LuaSnip Choice";
        module = "blink-cmp-luasnip-choice";
        fallbacks = [
          "buffer"
        ];
      };
      ecolog = {
        name = "ecolog";
        module = "ecolog.integrations.cmp.blink_cmp";
      };
      tw2css = {
        name = "cmp-tw2css";
        module = "blink.compat.source";
        transform_items.__raw = ''
          function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = '󱏿'
              item.kind_name = 'tw2css'
            end
            return items
          end
        '';
        should_show_items.__raw = ''
          function()
            local success, node = pcall(vim.treesitter.get_node, { ignore_injections = false })
            if not success or not node then return false end

            return vim.tbl_contains({ "block", "stylesheet", "descendant_selector" }, node:type())
          end
        '';
      };
      conv_commits = {
        name = "Conventional Commits";
        module = "blink-cmp-conventional-commits";
        fallbacks = [
          "buffer"
        ];
      };

    };
  };

  autoCmd = [
    {
      event = "User";
      pattern = [
        "NeogitCommitComplete"
        "NeogitPullComplete"
        "NeogitFetchComplete"
        "NeogitRebase"
        "NeogitReset"
        "NeogitMerge"
      ];
      desc = "Refersh the blink-cmp-git cache on every commit";
      callback.__raw = ''
        function()
          vim.api.nvim_command('BlinkCmpGitReloadCache')
        end
      '';
    }
  ];
}
