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
        on_attach.__raw = "function(client, bufnr) vim.lsp.inlay_hint(bufnr, true) end";
        capabilities.__raw = "require('cmp_nvim_lsp').default_capabilities()";
        root_dir.__raw = "require('lspconfig.util').root_pattern('tsconfig.json','package.json','.git')";
        settings.tsserver.format.enable = false;
      };
    };
  };
}
