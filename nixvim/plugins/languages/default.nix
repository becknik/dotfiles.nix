{ ... }:

{
  imports = [
    ./markdown.nix
    ./nix.nix
    ./latex.nix
    ./typescript-tools.nix
  ];

  # 󰲒 󰢱
  extraConfigLuaPost = ''
    wk.add {
      { "<leader>c", desc = "Code etc." },
      { "<leader>l", icon = "󰛦 ", desc = "Language-specific" },
    }
  '';
}
