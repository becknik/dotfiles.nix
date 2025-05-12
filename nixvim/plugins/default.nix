{ ... }:

{
  imports = [
    ./cmp
    ./lsp
    ./treesitter

    ./languages
    ./git

    ./ui
    ./telescope
    ./motion-and-pairs

    ./dap.nix

    ./which-key.nix
    ./luasnip.nix

    ./oil.nix
    ./toggle-term.nix

    ./refactoring.nix
    ./todo-comments.nix
  ];

  # global variable definitions
  extraConfigLuaPre = builtins.concatStringsSep "\n" [
    # using wk.add() for grouping descriptions
    # https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
    "local wk = require('which-key')"
  ];

  plugins = {

    tmux-navigator = {
      enable = true;
      settings = {
        disable_when_zoomed = 1;
        save_on_switch = 1;
      };
    };
  };
}

# TODO
# statuscol-nvim
# eyeliner
# vim-unimpaired
# nvim-ts-context-commentstring
# vim-repeat
# nvim-unception # Prevent nested neovim sessions | nvim-unception

# bleeding-edge plugins from flake inputs
# (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
