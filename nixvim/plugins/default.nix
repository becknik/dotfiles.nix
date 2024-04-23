{ withDefaultKeymapOptions, ... }:

{
  imports = [
    ./cmp
    ./lsp
    ./treesitter

    ./git
    ./languages
    ./dap.nix

    ./luasnip.nix
    ./telescope.nix

    ./oil.nix
    ./nvim-tree.nix
    ./bufferline.nix
    ./lualine.nix

    ./noice.nix
    ./toggle-term.nix

    ./refactoring.nix
    ./comment.nix
    ./todo-comments.nix
  ];

  opts.foldenable = false; # disable tree-sitter to fold the code on startup

  plugins = {
    # UI
    notify.enable = true;
    diffview.enable = true;

    # https://gitlab.com/HiPhish/rainbow-delimiters.nvim
    rainbow-delimiters.enable = true;
    indent-blankline.enable = true;
    # statuscol-nvim
    # which-key.enable = true; # personally finding this annoying
    # transparent.enable = false; # TODO first need terminal support for this

    # Navigation & Editing
    surround.enable = true;

    vim-matchup.enable = true;
    nvim-autopairs = {
      enable = true;
      settings.check_ts = true;
    };
    ts-autotag.enable = true;

    # TODO
    # eyeliner
    # vim-unimpaired
    # nvim-ts-context-commentstring
    # vim-repeat
    # nvim-unception # Prevent nested neovim sessions | nvim-unception

    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim

    # Further Tooling

    ## Language-specific
    nix.enable = true;
    nix-develop.enable = true;

    ## Application-specific
    #obsidian.enable = true; # TODO https://github.com/epwalsh/obsidian.nvim
  };
}
