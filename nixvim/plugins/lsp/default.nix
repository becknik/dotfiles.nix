{ withDefaultKeymapOptions, ... }:

{
  # https://www.reddit.com/r/neovim/comments/15oue2o/finally_a_robust_autoformatting_solution/
  imports = [
    ./format-and-fix

    ./language-servers
    ./keymaps.nix

    ./lspsaga.nix
  ];

  # https://github.com/neovim/nvim-lspconfig
  plugins = {
    lsp.enable = true;
    lsp.inlayHints = true;

    # LSP messages
    fidget = {
      enable = true;
      settings.logger.level = "info";

      # just need it for the conform hunk formatting progress indicator
      settings.notification.poll_rate = 25; # Hz, default is 10
    };

    # add pictrograms to lsp
    # configured manually in cmp.lua
    lspkind.enable = false;
  };
}
