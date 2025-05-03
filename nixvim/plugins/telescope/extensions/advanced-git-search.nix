{ withDefaultKeymapOptions, ... }:

{
  plugins.telescope.extensions.advanced-git-search = {
    enable = true;
    settings = {
      diff_plugin = "diffview";
    };
  };

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>gg", icon = "", desc = "Git Grep" },
      { "<leader>gr", icon = " " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>gg$";
      action = "AdvancedGitSearch search_log_content";
      options.cmd = true;
      options.desc = "Git Grep in History";
    }
    {
      key = "<leader>ggh";
      action = "AdvancedGitSearch search_log_content_file";
      options.cmd = true;
      options.desc = "Git Grep in History current file";
    }
    {
      key = "<leader>gr";
      action = "AdvancedGitSearch checkout_reflog";
      options.cmd = true;
      options.desc = "Git Reflog";
    }
  ];
}
