{ ... }:

{
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  config = {
    viAlias = true;
    vimAlias = true;

    clipboard = {
      providers.wl-copy.enable = true;
    };
    colorschemes.oxocarbon.enable = true;

    plugins.lazy.enable = true;
  };
}
