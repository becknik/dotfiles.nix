{ ... }:

{
  imports = [
    ./cmp
    ./lsp
    ./treesitter

    ./git
    ./languages

    ./luasnip.nix
    ./telescope.nix

    ./oil.nix
    ./nvim-tree.nix
    ./bufferline.nix
    ./lualine.nix

    ./refactoring.nix
  ];

  opts.foldenable = false; # disable tree-sitter to fold the code on startup

  plugins = {

    # Git Integration
    # fugitive.enable = false; # TODO redundancy?
    diffview.enable = true;

    # UI
    notify = {
      enable = true;
      fps = 60;
    };
    which-key.enable = true;
    navic.enable = true;
    todo-comments.enable = true;
    # https://gitlab.com/HiPhish/rainbow-delimiters.nvim
    rainbow-delimiters.enable = true;
    indent-blankline.enable = true;
    # https://github.com/shellRaining/hlchunk.nvim is this necessary?
    # statuscol-nvim

    # Navigation & Editing
    surround.enable = true;
    vim-matchup.enable = true;
    nvim-autopairs.enable = true;
    # eyeliner
    # vim-unimpaired
    # nvim-ts-context-commentstring
    # vim-repeat

    # Etc.
    # nvim-unception # Prevent nested neovim sessions | nvim-unception

    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    # which-key-nvim

    # nix.enable = true;
    nix-develop.enable = true;

    # transparent.enable = false; # TODO first need terminal support for this

    #obsidian.enable = true; # TODO https://github.com/epwalsh/obsidian.nvim
  };
}
