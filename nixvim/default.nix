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

    # plugins.lazy.enable = true;
  };
}
