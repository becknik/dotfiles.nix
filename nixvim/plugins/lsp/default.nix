{ withDefaultKeymapOptions, ... }:

{
  # https://www.reddit.com/r/neovim/comments/15oue2o/finally_a_robust_autoformatting_solution/
  imports = [
    ./format-and-fix

    ./language-servers
    ./keymaps.nix

    ./lspsaga.nix
    ./outline.nix
    ./glance.nix
    ./ecolog.nix
    ./classy.nix
    ./otter.nix
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
      settings.notification.poll_rate = 100; # Hz, default is 10
    };

    # add pictrograms to lsp
    # configured manually in cmp.lua
    lspkind.enable = false;
  };

  autoCmd = [
    {
      event = "TermOpen";
      callback.__raw = ''
        function(args)
          vim.bo[args.buf].buflisted = false
          vim.b[args.buf].lsp_disabled = true
        end
      '';
    }
  ];

}
