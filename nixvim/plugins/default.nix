{ ... }:

{
  imports = [
    ./cmp
    ./lsp
    ./treesitter

    ./luasnip.nix
    ./telescope.nix

    ./oil.nix
    ./bufferline.nix
    ./nvim-tree.nix
  ];

  opts.foldenable = false; # disable tree-sitter to fold the code on startup

  plugins = {

    # Git Integration Plugins
    gitsigns.enable = true;
    neogit.enable = true;
    # fugitive.enable = false; # TODO redundancy?
    diffview.enable = true;

    # Telescope & Extensions
    telescope.enable = true;

    # UI
    lualine.enable = true;
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

    # Etc.
    # nvim-unception # Prevent nested neovim sessions | nvim-unception

    # libraries that other plugins depend on
    # sqlite-lua
    # plenary-nvim
    # nvim-web-devicons
    # vim-repeat
    # ^ libraries that other plugins depend on
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
