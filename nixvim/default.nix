{ ... }:

{
  imports = [
    ./options.nix

    ./plugins
  ];

  config = {
    viAlias = true;
    vimAlias = true;

    clipboard.providers.wl-copy.enable = true;

    colorschemes.catppuccin.enable = true;
    # colorschemes.oxocarbon.enable = true;
    # colorschemes.onedark.enable = true;
    # colorschemes.tokyonight.enable = true;

    globals.mapleader = " "; # "," "\"

    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = false; # default
        plugins = true; # some issues with some plugins like neoclip and sqlite
      };
    };

    # plugins.lazy.enable = true;
  };
}
