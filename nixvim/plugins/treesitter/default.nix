{ defaultKeymapOptions, ... }:

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

  plugins.treesitter-context = {
    enable = true;
    mode = "cursor"; # "topline"
  };
  # TODO https://github.com/nvim-treesitter/nvim-treesitter-context?tab=readme-ov-file#appearance
  # TreesitterContext
  # hi TreesitterContextLineNumberBottom gui=underline guisp=Grey

  keymaps = [{
    # https://github.com/nvim-treesitter/nvim-treesitter-context?tab=readme-ov-file#jumping-to-context-upwards
    action = "function() require(\"treesitter-context\").go_to_context(vim.v.count1) end";
    key = "<leader>c";
    options = defaultKeymapOptions;
  }];
}
