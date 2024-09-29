{ ... }:

{
  imports = [
    ./options.nix
    ./keymaps.nix

    ./plugins
  ];

  config = {
    viAlias = true;
    vimAlias = true;

    clipboard = {
      providers.wl-copy.enable = true;
    };

    colorschemes.catppuccin.enable = true;
    # colorschemes.oxocarbon.enable = true;
    # colorschemes.onedark.enable = true;
    # colorschemes.tokyonight.enable = true;

    performance = {
      byteCompileLua = {
        enable = true;
        # configs = true;
        # initLua = true;
        nvimRuntime = false;
        plugins = true; # some issues with some plugins like neoclip and sqlite
      };
    };

    # plugins.lazy.enable = true;
  };
}
