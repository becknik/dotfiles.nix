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

  extraPlugins = with pkgs; [
    # TODO neodev doesn't work?
    vimPlugins.neodev-nvim
    # TODO nvim-lsp-file-operations don't work?
    # (pkgs.vimUtils.buildVimPlugin {
    #   name = "nvim-lsp-file-operations";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "antosha417";
    #     repo = "nvim-lsp-file-operations";
    #     rev = "223aca86b737dc66e9c51ebcda8788a8d9cc6cf2";
    #     hash = "sha256-eXOqhfzDK+Jv5bV1wdWT4IA/wBAdkhWV+75HoNcYaR8=";
    #   };
    # })
  ];

  # https://github.com/folke/neodev.nvim?tab=readme-ov-file#-setup
  extraConfigLuaPre = ''
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    require("neodev").setup({
      -- override = functionn(root_dir, options) end,
    })
  '';

  # extraConfigLuaPost = ''
  # require("lsp-file-operations").setup()
  # '';
  # plugins.lsp.servers.lua-ls.settings.Lua.completion.callSnippet = "Replace";
}
