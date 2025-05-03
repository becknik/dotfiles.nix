{ ... }:

{
  imports = [
    ./bufferline.nix
    ./lualine.nix
  ];

  plugins = {
    web-devicons.enable = true;

    notify = {
      enable = true;
      settings.stages = "fade";
    };
    # https://github.com/HiPhish/rainbow-delimiters.nvim
    rainbow-delimiters.enable = true;
    indent-blankline.enable = true;
  };

}
