{ pkgs, ... }:

{
  plugins.otter = {
    enable = true;
    package = pkgs.vimPlugins.otter-nvim;

    settings = {
      buffers = {
        preambles.css = [ "_ {" ];
        postambles.css = [ "}" ];
      };
    };
  };
}
