{ withDefaultKeymapOptions, ... }:

{
  # TODO not sure why there are so many options after the refactoring...

  # https://github.com/folke/trouble.nvim
  plugins = {
    trouble = {
      enable = true;

      settings = {
        auto_close = true;
        focus = true;
      };
    };

    telescope.settings.defaults.mappings = {
      i = {
        "<c-t>".__raw = "require('trouble.sources.telescope').add";
      };
      n = {
        "<c-t>".__raw = "require('trouble.sources.telescope').add";
      };
    };
  };

  plugins.trouble.luaConfig.post = ''
    wk.add {
      { "<leader>du", icon = " 󱖫 " },
      { "<leader>dd", icon = " 󱖫 " },
      { "<leader>dt", icon = " 󱖫 " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>dd";
      action = "Trouble diagnostics";
      options.cmd = true;
      options.desc = "Diagnostic List";
    }
    {
      key = "<leader>du";
      action = "Trouble quickfix";
      options.cmd = true;
      options.desc = "Quick Fix List";
    }
    {
      key = "<leader>dt";
      action = "Trouble telescope";
      options.cmd = true;
      options.desc = "Telescope";
    }
  ];
}
