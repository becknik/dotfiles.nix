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
      extensions.styled = "css";
      filetype_aliases.styled = "css";
      buffers = {
        preambles.styled = [ "_ {" ];
        postambles.styled = [ "}" ];
      };
    };
  };

}
