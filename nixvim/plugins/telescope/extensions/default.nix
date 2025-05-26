{ withDefaultKeymapOptions, ... }:

{
  imports = [
    ./file-browser.nix
    ./zoxide.nix
  ];

  plugins.telescope = {
    # https://youtu.be/u_OORAL_xSM?feature=shared&t=442
    extensions = {
      fzf-native.enable = true;
      frecency.enable = true;
      frecency.settings = {
        db_version = "v2";
        preceding = "opened";
        hide_current_buffer = true;
        show_filter_column = false;
      };
      live-grep-args.enable = true;
      ui-select.enable = true; # replaces the vim.ui.select with telescope
      undo.enable = true;
    };
  };

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>fG", icon = " " },
      { "<leader>ff", icon = " 󰋚 " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>ff";
      action = "Telescope frecency workspace=CWD";
      options.cmd = true;
      options.desc = "Find in Frecency";
    }
    {
      key = "<leader>fG";
      action = "Telescope live_grep_args live_grep_args";
      options.cmd = true;
      options.desc = "Search in live Grep (with args)";
    }
    {
      key = "<leader>u";
      action = "Telescope undo";
      options.cmd = true;
      options.desc = "Find in Undo tree";
    }
  ];

  autoCmd = [
    {
      event = [ "VimEnter" ];
      command = "FrecencyValidate";
    }
  ];
}
