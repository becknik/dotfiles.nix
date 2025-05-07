{ config, lib, ... }:

{
  imports = [
    ./markdown.nix
    ./nix.nix
    ./latex.nix
  ];

  # 󰲒 󰢱
  extraConfigLuaPost = ''
    wk.add {
      { "<leader>l", icon = "󰛦 ", desc = "Language-specific" },
    }
  '';

  plugins.typescript-tools = {
    enable = true;

    settings = {
      server = {
        on_attach = "_M.lspOnAttach";
        capabilities.__raw = "vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())";
        root_dir.__raw = "require('lspconfig.util').root_pattern('tsconfig.json')";
        settings.tsserver.format.enable = false;
      };
    };
  };
}
