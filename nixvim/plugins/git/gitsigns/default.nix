{ ... }:

{
  plugins = {
    gitsigns = {
      enable = true;

      settings = {
        current_line_blame_formatter = " <author>, <author_time>, #<abbrev_sha> - <summary> ";
        current_line_blame_opts = {
          delay = 250;
          ignore_whitespace = true; # ignore whitespace changes
        };

        numhl = true;
        trouble = true;

        diff_opts = {
          algorithm = "histogram";
          ignore_whitespace = false;
          ignore_whitespace_change = false;
          ignore_whitespace_change_at_eol = false;
          indent_heuristic = false;
        };

        signs = {
          add = { text = "┃"; };
          change = { text = "󰇝"; }; # 󰇝󱋱
          delete.show_count = true;
          changedelete.show_count = true;
        };

        on_attach = (builtins.readFile ./keybindings.lua);
      };
    };
  };
}
