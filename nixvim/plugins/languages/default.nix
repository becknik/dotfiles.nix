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
      { "<leader>l", icon = "󰛦 ", desc = "Language-specific" },
    }
  '';
}
