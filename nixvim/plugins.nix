{ ... }:

{
  imports = [
    ./plugins/cmp.nix
    ./plugins/lsp.nix
  ];


  opts.foldenable = false; # disable tree-sitter to fold the code on startup?

  plugins = {
    luasnip.enable = true;

    treesitter = {
      enable = true;
      indent = true;
      folding = true;
      nixvimInjections = true;
    };
    treesitter-context.enable = true;
    treesitter-textobjects.enable = true;


    nix.enable = true;
    nix-develop.enable = true;

    telescope.enable = true;
    todo-comments.enable = true;
    gitsigns.enable = true;

    lualine.enable = true;
    # transparent.enable = false; # TODO first need terminal support for this

    #obsidian.enable = true; # TODO https://github.com/epwalsh/obsidian.nvim
  };
}
