{ ... }:

{
  imports = [ ./keymaps.nix ];

  plugins = {
    gitsigns = {
      enable = true;

      settings = {
        # for the virtual text displayed at the end of the line
        current_line_blame_formatter = "<author> #<abbrev_sha> (<author_time:%R>) - <summary> ";
        current_line_blame_opts = {
          delay = 250;
          ignore_whitespace = true;
        };

        numhl = true;
        trouble = true;

        diff_opts = {
          algorithm = "histogram";
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
      };
    };
  };
}
