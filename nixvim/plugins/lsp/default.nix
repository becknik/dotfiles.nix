{ pkgs, ... }:

{
  # https://www.reddit.com/r/neovim/comments/15oue2o/finally_a_robust_autoformatting_solution/
  # https://www.reddit.com/r/neovim/comments/16hpxwu/conformnvim_another_plugin_to_replace_nullls/
  imports = [
    ./language-servers.nix
    ./keymaps.nix

    ./lspsaga.nix
    ./conform.nix
    ./trouble.nix
  ];

  # aiming to use fidget only for lsp status messages/ progress
  # https://github.com/j-hui/fidget.nvim
  # TODO doesn't work
  plugins.fidget = {
    enable = true;
    logger.level = "info";
  };
  /*   autoCmd = [{
    event = [ "BufEnter" "BufWinEnter" ];
    command = ":Fidget suppress"; # suppress fidget notification handling
  }]; */


  # https://github.com/neovim/nvim-lspconfig
  plugins = {
    lsp.enable = true;

    lsp-format.enable = false; # using conform.nix
    lspkind.enable = false; # configured manually in cmp.lua
  };

  # TODO neodev doesn't work?
  extraPlugins = with pkgs; [
    vimPlugins.neodev-nvim
  ];

  # https://github.com/folke/neodev.nvim?tab=readme-ov-file#-setup
  extraConfigLuaPre = ''
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    require("neodev").setup({
      -- override = functionn(root_dir, options) end,
    })
  '';
  # plugins.lsp.servers.lua-ls.settings.Lua.completion.callSnippet = "Replace";
}
