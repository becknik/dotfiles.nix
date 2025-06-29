{ ... }:

{
  imports = [
    ./markdown.nix
    ./latex.nix
  ];

  extraConfigLuaPost = ''
    wk.add {
      { "<leader>l", icon = "󰲒 ", desc = "Language-specific" },
    }
  '';
}
