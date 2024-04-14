{ ... }:

{
  plugins.telescope = {
    enable = true;

    extensions = {
      fzf-native = {
        enable = true;
      };
    };

    settings = {
      defaults = {
        file_ignore_patterns = [ "^.git/" ];
      };
    };

    # TODO doesn't work?
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
    keymaps = {
      "<leader>tf" = "find_files";
      "<leader>tg" = "live_grep";
      "<leader>tb" = "buffers";
      "<leader>th" = "help_tags";
    };
  };
}
