{ ... }:

{
  imports = [
    ./options.nix

    ./plugins
  ];

  config.globals.mapleader = " "; # "," "\"

  config = {
    viAlias = true;
    vimAlias = true;

    clipboard.providers.wl-copy.enable = true;

    # colorschemes.kanagawa.enable = true;
    colorschemes.rose-pine.enable = true;

    env = { };
    files = { };
    impureRtp = false; # "keep .config/nvim & .config/nvim/after in runtime path"

    withPython3 = false;
    withRuby = false;

    # experimental lua loader
    luaLoader.enable = true;
    performance = {
      byteCompileLua = {
        enable = true;
        # :Telescope keymaps doesn't work anymore when setting either to true
        initLua = false;
        plugins = false;
      };
    };

    editorconfig.enable = true;
    plugins.lz-n.enable = true;
  };
}
