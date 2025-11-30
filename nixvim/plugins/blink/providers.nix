{ config, ... }:

{
  plugins.blink-cmp-git.enable = true;
  plugins.blink-cmp-spell.enable = true;
  plugins.blink-cmp-dictionary.enable = true;
  plugins.blink-emoji.enable = true;
  # https://github.com/disrupted/blink-cmp-conventional-commits
  # https://github.com/alexandre-abrioux/blink-cmp-npm.nvim
  # https://github.com/ssstba/ecolog.nvim
  # https://github.com/Dynge/gitmoji.nvim

  plugins.blink-cmp.luaConfig.pre = ''
    function is_in_string_like_node()
      if vim.bo.buftype == "prompt" then
        return false
      elseif vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype) then
        return true
      end

      local row, column = unpack(vim.api.nvim_win_get_cursor(0))
      local success, node = pcall(vim.treesitter.get_node, {
        bufnr = 0,
        pos = { row - 1, math.max(0, column - 1) } -- seems to be necessary...
      })

      local reject = { "comment", "line_comment", "block_comment", "string_start", "string_fragment", "string_content", "string_end" }
      return (success and node and vim.tbl_contains(reject, node:type()))
    end
  '';
  plugins.blink-cmp.settings.sources = {
    default = [
      "lsp"
      "path"
      "buffer"
      "emoji"
      "git"
    ];
    per_filetype.__raw = ''
      {
        markdown = {
          inherit_defaults = true,
          "spell",
          "dictionary",
        },
        codecompanion = {
          inherit_defaults = true,
          "spell",
          "dictionary",
        },
        gitcommit = {
          inherit_defaults = true,
          "spell",
        },
      }
    '';

    providers = {
      git = {
        # https://github.com/Kaiser-Yang/blink-cmp-git
        module = "blink-cmp-git";
        name = "git";
        max_items = config.plugins.blink-cmp.settings.completion.list.max_items / 3;
        should_show_items.__raw = "is_in_string_like_node";
      };
      emoji = {
        # https://github.com/moyiz/blink-emoji.nvim
        module = "blink-emoji";
        name = "emoji";
        score_offset = 100;
        max_items = config.plugins.blink-cmp.settings.completion.list.max_items / 3;
        should_show_items.__raw = "is_in_string_like_node";
      };
      spell = {
        # https://github.com/ribru17/blink-cmp-spell
        module = "blink-cmp-spell";
        name = "spell";
      };
      dictionary = {
        # https://github.com/Kaiser-Yang/blink-cmp-dictionary
        module = "blink-cmp-spell";
        name = "dictionary";
        min_keyword_length = 3;
      };
    };
  };
}
