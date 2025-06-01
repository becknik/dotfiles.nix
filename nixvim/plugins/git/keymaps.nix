{ withDefaultKeymapOptions, mapToModeAbbr, ... }:
{

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>g", desc = "Git" },
      { "<leader>gb", icon = "  " },
      { "<leader>gs", icon = " 󱖫 " },
      { "<leader>gz", icon = "  " },
      { "<leader>g$", icon = "  " },
      { "<leader>gh", icon = "  " },
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
      action = "git_branches";
      options.desc = "find Git Branch";
      # <C-t>, rebase action<C-r>, create action <C-a>, switch action <C-s>, delete action <C-d> and merge action <C-y>
    };
    "<leader>gs" = {
      action = "git_status theme=ivy";
      options.desc = "find in Git Status";
    };
    "<leader>gz" = {
      action = "git_stash ";
      options.desc = "find Git Stash";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>gh";
      action = "Telescope git_bcommits theme=ivy";
      options.cmd = true;
      options.desc = "find Git Commit for current buffer";

      mode = mapToModeAbbr [ "normal" ];
    }
    {
      key = "<leader>gh";
      action = "Telescope git_bcommits_range thmme=ivy";
      options.cmd = true;
      options.desc = "find Git Commits for selection";

      mode = mapToModeAbbr [ "visual_select" ];
    }
  ];
}
