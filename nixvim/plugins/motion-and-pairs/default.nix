{ ... }:

{
  imports = [
  ];

  plugins = {
    ## Motion

    nvim-surround.enable = true;
    # https://github.com/kylechui/nvim-surround

    comment.enable = true;

    # extends % to language-specific words and not just single characters
    vim-matchup = {
      # https://github.com/andymass/vim-matchup/
      # TODO load this on event = "Syntax"
      enable = true;
      treesitter = {
        enable = true;
        # include traditional vim regex matches for symbols
        include_match_words = true;
        # disable for languages
        disable = [ ];
      };
    };

    ## Pairs

    nvim-autopairs = {
      # https://github.com/windwp/nvim-autopairs/?tab=readme-ov-file#default-values
      enable = true;
      # user treesitter to chech for pairs
      settings.check_ts = true;
    };

    ts-autotag.enable = true;
    # https://github.com/windwp/nvim-ts-autotag/
  };
}
