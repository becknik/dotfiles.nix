{ withDefaultKeymapOptions, ... }:

{
  # https://www.reddit.com/r/neovim/comments/15oue2o/finally_a_robust_autoformatting_solution/
  # https://www.reddit.com/r/neovim/comments/16hpxwu/conformnvim_another_plugin_to_replace_nullls/
  imports = [
    ./language-servers.nix
    ./keymaps.nix

    ./lspsaga.nix
    ./lsp-signature.nix
    ./conform.nix
    ./trouble.nix
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

    lsp-lines.enable = true;
  };

  plugins.lsp-lines.luaConfig.post = ''
    wk.add {
      { "<leader>dt", icon = " 󰊠 " },
      }
  '';
  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>dt";
      action.__raw = "function() require('lsp_lines').toggle() end";
      options.desc = "Toggle lsp_lines";
    }
  ];
}
