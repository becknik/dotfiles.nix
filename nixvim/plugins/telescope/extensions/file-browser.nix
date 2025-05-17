{ withDefaultKeymapOptions, ... }:

{
  plugins.telescope.extensions.file-browser = {
    enable = true;
    settings = {
      theme = "ivy";
      collapse_dirs = true; # with only one element
      prompt_path = true; # add path to prompt
      follow_symlinks = true;

      mappings.n = {
        "-" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
      };
    };
  };

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>fb", icon = "  " },
      { "<leader>f/", icon = "  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>f/";
      action = "Telescope file_browser initial_mode=normal";
      options.cmd = true;
      options.desc = "find in File Browser /";
    }
    {
      key = "<leader>fb";
      action = "Telescope file_browser path=%:p:h select_buffer=true initial_mode=normal";
      options.cmd = true;
      options.desc = "find in File browser ./";
    }
  ];
}
