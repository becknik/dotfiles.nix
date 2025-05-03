{ ... }:

{
  imports = [
    ./textobjects.nix
    ./context.nix
  ];

  # disable tree-sitter to fold the code on startup
  opts.foldenable = false;

  plugins.treesitter = {
    enable = true;

    folding = true;
    nixvimInjections = true;

    settings = {
      # grammars managed trough the plugin:
      # auto install missing parsers when entering buffer
      auto_install = true;
      ensure_installed = [ ];
      ignore_installed = [ ];

      highlight.enable = true;
      indent.enable = true;

      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<leader>vi";
          node_incremental = "<leader>vn";
          scope_incremental = "<leader>vs";
          node_decremental = "<leader>vd";
        };
      };
    };
  };

  plugins.treesitter-refactor = {
    enable = true;
    highlightDefinitions.enable = true;
  };
}
