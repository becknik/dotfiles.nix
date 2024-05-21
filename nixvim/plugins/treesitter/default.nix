{ withDefaultKeymapOptions, ... }:

{
  imports = [ ./textobjects.nix ];

  plugins.treesitter = {
    enable = true;
    indent = true;
    folding = true;
    nixvimInjections = true;

    incrementalSelection = {
      enable = true;
      keymaps = {
        initSelection = "gni"; # g(s)elect node increase
        nodeIncremental = "gni";
        nodeDecremental = "gnd";
        scopeIncremental = "gsi";
      };
    };
  };

  plugins.treesitter-refactor = {
    enable = true;
    highlightDefinitions.enable = true;
  };

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
    key = "<leader>con";
    action = "function() require('treesitter-context').go_to_context(vim.v.count1) end";
    lua = true;
  }];
}
