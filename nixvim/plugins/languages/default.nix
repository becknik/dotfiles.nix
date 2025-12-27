{ ... }:

{
  imports = [
    ./markdown.nix
    ./vimtex.nix
    ./typst.nix
    ./css-modules.nix
  ];

  extraConfigLuaPost = ''
    wk.add {
      { "<leader>l", icon = "󰲒 ", desc = "Language-specific" },
    }
  '';
}
