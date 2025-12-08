{ ... }:

{
  imports = [
    ./markdown.nix
    ./vimtex.nix
    ./typst.nix
  ];

  extraConfigLuaPost = ''
    wk.add {
      { "<leader>l", icon = "󰲒 ", desc = "Language-specific" },
    }
  '';
}
