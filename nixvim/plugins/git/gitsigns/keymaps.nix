{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  extraConfigLua = ''
    wk.add {
      { "<leader>h", desc = "GitSigns", icon = " " },
      { "<leader>hs", icon = "" },
      { "<leader>hS", icon = "" },
      { "<leader>hr", icon = "" },
      { "<leader>hR", icon = "" },
      { "<leader>hu", icon = "󰕍" },
      { "<leader>hd", icon = " " },
      { "<leader>hD", icon = " " },

      { "<leader>tb", icon = " 󰘤  " },
      { "<leader>tx", icon = " 󰦨 " },
      { "<leader>th", icon = " 󰘤  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>hs";
      action.__raw = "require'gitsigns'.stage_hunk";
      mode = mapToModeAbbr [ "normal" ];
      options.desc = "Stage Hunk under cursor (toggle)";
    }
    {
      key = "<leader>hs";
      action.__raw = "function() require'gitsigns'.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end";
      mode = mapToModeAbbr [ "visual_select" ];
      options.desc = "Stage Hunk selection (toggle)";
    }
    {
      key = "<leader>hS";
      action.__raw = "require'gitsigns'.stage_hunk";
      options.desc = "Stage Hunks in buffer";
    }
    {
      key = "<leader>hu";
      action.__raw = "require'gitsigns'.undo_stage_hunk";
      options.desc = "Undo stage Hunk";
    }

    {
      key = "ih";
      action.__raw = "require'gitsigns'.select_hunk";
      mode = mapToModeAbbr [
        "operator_pending"
        "visual_select"
      ];
      options.desc = "hunk";
    }

    {
      key = "<leader>hr"; # restore sadly doesn't exist in NeoGit
      action.__raw = "require'gitsigns'.reset_hunk";
      mode = mapToModeAbbr [ "normal" ];
      options.desc = "Reset Hunk under cursor";
    }
    {
      key = "<leader>hr";
      action.__raw = "function() require'gitsigns'.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end";
      mode = mapToModeAbbr [ "visual_select" ];
      options.desc = "Reset Hunk selection";
    }
    {
      key = "<leader>hR";
      action.__raw = "require'gitsigns'.reset_buffer";
      options.desc = "Reset Hunks in buffer";
    }

    {
      key = "<leader>hp";
      action.__raw = "require'gitsigns'.preview_hunk";
      options.desc = "Preview Hunk diff under cursor";
    }
    {
      key = "<leader>hb";
      action.__raw = "function() require'gitsigns'.blame_line { full = true } end";
      options.desc = "Blame line";
    }

    {
      key = "<leader>hd";
      action.__raw = "function() require'gitsigns'.diffthis(nil, { vertical = true }) end";
      options.desc = "Diff file";
    }
    {
      key = "<leader>hD";
      action.__raw = "function() require'gitsigns'.diffthis('~', { vertical = true }) end";
      options.desc = "Diff file with HEAD~";
    }

    {
      key = "<leader>tb";
      action.__raw = "require'gitsigns'.toggle_current_line_blame";
      options.desc = "Toggle current line blame";
    }
    {
      key = "<leader>tx";
      action.__raw = "require'gitsigns'.toggle_deleted";
      options.desc = "Toggle visibility of deleted lines";
    }
    {
      key = "<leader>th";
      action.__raw = "require'gitsigns'.toggle_linehl";
      options.desc = "Toggle Hunk Highlighting";
    }
  ];
}
