{ withDefaultKeymapOptions, ... }:

{
  imports = [
    ./lualine.nix
  ];

  plugins = {
    notify = {
      enable = true;
      settings = {
        background_colour = "#000000"; # removes annoying notification sometimes appearing when exiting commit editor
        stages = "fade";
      };
    };
    # https://github.com/HiPhish/rainbow-delimiters.nvim
    rainbow-delimiters.enable = true;
    indent-blankline.enable = true;
  };

  plugins.notify.luaConfig.post = ''
    wk.add {
      { "<leader>nd", icon = "󰎟" },
      { "<leader>no", icon = "󰎟" },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>nd";
      action.__raw = "function() require'notify'.dismiss() end";
      options.desc = "Dismiss all Notifications";
    }
    {
      key = "<leader>no";
      action = "Telescope notify";
      options.cmd = true;
      options.desc = "Search Notifications";
    }
  ];
}
