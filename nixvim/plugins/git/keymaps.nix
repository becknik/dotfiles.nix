{ ... }:
{

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>g", desc = "Git" },
      { "<leader>gb", icon = "  " },
      { "<leader>gs", icon = " 󱖫 " },
      { "<leader>gZ", icon = "  " },
      { "<leader>g$", icon = "  " },
    }
  '';

  plugins.telescope.keymaps = {
    # Git
    # inspired by Neogit default Bindings
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers
    "<leader>g$" = {
      action = "git_commits";
      # (reset <C-r>m|s|h)
      options.desc = "find in Git History";
    };
    "<leader>gb" = {
      action = "git_branches theme=ivy";
      options.desc = "find Git Branch";
      # <C-t>, rebase action<C-r>, create action <C-a>, switch action <C-s>, delete action <C-d> and merge action <C-y>
    };
    "<leader>gs" = {
      action = "git_status theme=ivy initial_mode=normal";
      options.desc = "find in Git Status";
    };
    "<leader>gZ" = {
      action = "git_stash theme=ivy initial_mode=normal";
      options.desc = "find Git Stash";
    };
  };
}
