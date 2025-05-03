{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/polarmutex/git-worktree.nvim/
  plugins.git-worktree = {
    enable = true;
    enableTelescope = true;
  };

  plugins.neogit.luaConfig.post = ''
    wk.add {
      { "<leader>gt", icon = "󱘎" },
      { "<leader>gtc", icon = "󱘎" },
      { "<leader>gts", icon = "󱘎" },
      { "<leader>gtd", icon = "󱘎" },
    }
  '';

  extraConfigLuaPost = ''require("telescope").load_extension("git_worktree")'';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>gtc";
      action.__raw = "function() require'git-worktree'.create_worktree() end";
      options.desc = "Create Git Worktree";
    }
    {
      key = "<leader>gts";
      action.__raw = "function() require'git-worktree'.switch_worktree() end";
      options.desc = "Switch Git Worktree";
    }
    {
      key = "<leader>gtd";
      action.__raw = "function() require'git-worktree'.delete_worktree() end";
      options.desc = "Delete Git Worktree";
    }
  ];
}
