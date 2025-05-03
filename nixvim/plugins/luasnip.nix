{ fetchFromGitHub, pkgs, ... }:

{
  plugins.luasnip = {
    enable = true;

    lazyLoad.enable = true;
    lazyLoad.settings.event = "InsertEnter";

    settings = {
      enable_autosnippets = true;
      # store_selection_keys = "<Tab>";
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
      {
        lazyLoad = true;
        paths = "${pkgs.vimPlugins.friendly-snippets}";
        # exclude = []; include = [];
      }
      # TODO this isn't working...
      {
        lazyLoad = true;
        paths = [{ __raw = "vim.fn.expand('~/.config/VSCodium/User')"; }];

      }
    ];
  };
  # keymaps = {};
}
