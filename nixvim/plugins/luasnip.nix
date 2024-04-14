{ pkgs, ... }:

{
  plugins.luasnip = {
    enable = true;

    # TODO put luasnips under version control somehow
    fromLua = [
      { lazyLoad = true; paths = "$HOME/.nvim/luasnips"; }
    ];
    fromVscode = [
      # exclude = []; include = [];
      { lazyLoad = true; paths = "${pkgs.vimPlugins.friendly-snippets}"; } # TODO causes possible infinite recursion
    ];
  };
  # keymaps = {};
}
