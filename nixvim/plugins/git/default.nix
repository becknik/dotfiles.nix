{ withDefaultKeymapOptions, ... }:

{
  imports = [
    ./gitsigns.nix
    ./neogit.nix
  ];

  plugins.git-worktree = {
    enable = true;
    enableTelescope = true;
    changeDirectoryCommand = "cd"; # tcd for the current vim tab only
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>fw";
      action = "function() require('telescope').extensions.git_worktree.git_worktrees() end";
      lua = true;
    }
    {
      key = "<leader>wt";
      action = "function() require('telescope').extensions.git_worktree.create_git_worktree() end";
      lua = true;
    }
    # <Enter> - switches to that worktree
    # <c-d> - deletes that worktree
    # <c-f> - toggles forcing of the next deletion
  ];
}
