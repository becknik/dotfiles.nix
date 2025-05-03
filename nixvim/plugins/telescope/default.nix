{ helpers, ... }:

{
  imports = [
    ./extensions
    ./keymaps.nix
  ];

  plugins.telescope = {
    enable = true;

    settings = {
      defaults = {
        file_ignore_patterns = [ "^.git/" ];
        dynamic_preview_title = true; # necessary for neoclip previews

        # https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
        # https://github.com/nvim-telescope/telescope.nvim/tree/master?tab=readme-ov-file#default-mappings
        mappings = {
          n."q" = "close";
        };
      };
    };
  };
}
