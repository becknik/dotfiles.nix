{ withDefaultKeymapOptions, ... }:

{
  imports = [
    ./lualine.nix
    ./ccc.nix
  ];

  plugins = {
    notify = {
      enable = true;
      settings = {
        background_colour = "#000000"; # removes annoying notification sometimes appearing when exiting commit editor
        stages = "static";
        timeout = 2500;
      };
    };
    # https://github.com/HiPhish/rainbow-delimiters.nvim
    rainbow-delimiters.enable = true;
  };

  plugins.notify.luaConfig.post = ''
    wk.add {
      { "<leader>n", icon = "󰎟", desc = "Notifications" },
      { "<leader>nd", icon = "󰎟" },
      { "<leader>nf", icon = " 󰎟" },

      { "<leader>no", icon = " " },
    }

    -- override
    local _notify = vim.notify
    vim.notify = function(msg, level, opts)
      if msg == "No information available" then
        return
      end
      _notify(msg, level, opts)
    end
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>nd";
      action.__raw = "function() require'notify'.dismiss() end";
      options.desc = "Dismiss all Notifications";
    }
    {
      key = "<leader>nf";
      action = "Telescope notify theme=ivy";
      options.cmd = true;
      options.desc = "Search Notifications";
    }
    {
      key = "<leader>no";
      action = "nohlsearch";
      options.cmd = true;
      options.desc = ":nohlsearch";
    }
  ];
}
