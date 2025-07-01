{ ... }:

{
  imports = [
    ./markdown.nix
    ./vimtex.nix
  ];

  extraConfigLuaPost = ''
    wk.add {
      { "<leader>l", icon = "󰲒 ", desc = "Language-specific" },
    }
  '';
}
