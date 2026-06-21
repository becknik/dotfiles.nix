{ pkgs, ... }:

{
  plugins.otter = {
    enable = true;
    package = pkgs.vimPlugins.otter-nvim.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        ./otter-filetype-alias-for-styled-components.patch
      ];
    });

    settings = {
      buffers = {
        preambles.css = [ "_ {" ];
        postambles.css = [ "}" ];
      };
    };
  };
}
