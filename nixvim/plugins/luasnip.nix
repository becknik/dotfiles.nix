{ fetchFromGitHub, pkgs, ... }:

{
  plugins.luasnip = {
    enable = true;

    extraConfig = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
    fromLua =
      let
        luasnips-repo = fetchFromGitHub {
          owner = "becknik";
          repo = "luasnips";
          rev = "25a3d42e32e5f4e37732debfc525bebb136212ca";
          hash = "sha256-s6NAjR+Qgy4R4hKfrl5tk+gXhWXuaGc8fytlPzQAo2U=";
        };
      in
      [
        { paths = "${luasnips-repo}"; }
      ];
    fromVscode = [
      # exclude = []; include = [];
      { lazyLoad = true; paths = "${pkgs.vimPlugins.friendly-snippets}"; } # TODO causes possible infinite recursion
    ];
  };
  # keymaps = {};
}
