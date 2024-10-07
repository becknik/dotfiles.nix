{ withDefaultKeymapOptions, ... }:

{
  plugins.git-worktree = {
    enable = true;
    enableTelescope = true;
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>wtc";
      action = "function() telescope.extensions.git_worktree.create_git_worktree() end";
      lua = true;
      options.desc = "Create git worktree in telescope";
    }
    {
      key = "<leader>wts";
      action = "function() telescope.extensions.git_worktree.git_worktrees() end";
      lua = true;
      options.desc = "Find git worktree in telescope";
    }
  ];
}
