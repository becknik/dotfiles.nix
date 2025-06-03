{ withDefaultKeymapOptions, ... }:

{
  # https://www.reddit.com/r/neovim/comments/15oue2o/finally_a_robust_autoformatting_solution/
  imports = [
    ./format-and-fix

    ./language-servers
    ./keymaps.nix

    ./lspsaga.nix
    ./lsp-signature.nix
  ];

  # https://github.com/neovim/nvim-lspconfig
  plugins = {
    lsp.enable = true;
    lsp.inlayHints = true;

    # LSP messages
    fidget = {
      enable = true;
      settings.logger.level = "info";

      # just use for lsp & let notify handle the rest
      settings.notification.poll_rate = 1; # Hz
    };

    # add pictrograms to lsp
    # configured manually in cmp.lua
    lspkind.enable = false;
  };
}
