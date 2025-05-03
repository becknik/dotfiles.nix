{ withDefaultKeymapOptions, ... }:

{
  plugins.treesitter-context = {
    enable = true;
    settings = {
      mode = "cursor"; # "topline"
      multilineThreshold = 10; # max: function with 10 newline-separated variables; default: 20
      maxLines = 20;
    };
  };

  autoCmd = [
    # https://github.com/nvim-treesitter/nvim-treesitter-context?tab=readme-ov-file#appearance
    {
      event = [ "BufEnter" "BufWinEnter" ];
      command = "hi TreesitterContextBottom gui=underline guisp=grey";
    }
    {
      event = [ "BufEnter" "BufWinEnter" ];
      command = "hi TreesitterContextLineNumberBottom guibg=grey guibg=white";
    }
  ];

  keymaps = withDefaultKeymapOptions [{
    # https://github.com/nvim-treesitter/nvim-treesitter-context?tab=readme-ov-file#jumping-to-context-upwards
    # TODO find better key for this
    key = "<leader>con";
    action.__raw = "function() require'treesitter-context'.go_to_context(vim.v.count1) end";
    options.desc = "jump to next Treesitter Context";
  }];
}
