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
      { "<leader>hv", icon = "󰕜" },
      { "<leader>hd", icon = "" },
      { "<leader>hD", icon = "" },

      { "<leader>tb", icon = " 󰘤  " },
      { "<leader>tx", icon = " 󰦨 " },
      { "<leader>th", icon = " 󰘤  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>hs";
      action = "Gitsigns stage_hunk";
      options.cmd = true;
      mode = mapToModeAbbr [ "normal" ];
      options.desc = "Stage Hunk under cursor";
    }
    {
      key = "<leader>hs";
      action.__raw = "function() require'gitsigns'.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end";
      mode = mapToModeAbbr [ "visual_select" ];
      options.desc = "Stage Hunk selection";
    }
    {
      key = "<leader>hS";
      action = "Gitsigns stage_buffer";
      options.cmd = true;
      options.desc = "Stage Hunks in buffer";
    }

    {
      key = "<leader>hu";
      action = "Gitsigns undo_stage_hunk";
      options.cmd = true;
      options.desc = "Undo stage Hunk";
    }
    {
      key = "<leader>hv";
      action = "Gitsigns select_hunk";
      options.cmd = true;
      options.desc = "staged Hunk under cursor in Visual mode";
    }

    {
      key = "<leader>hr"; # restore sadly doesn't exist in NeoGit
      action = "Gitsigns reset_hunk";
      options.cmd = true;
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
      action = "Gitsigns reset_buffer";
      options.cmd = true;
      options.desc = "Reset Hunks in buffer";
    }

    {
      key = "<leader>hp";
      action = "Gitsigns preview_hunk";
      options.cmd = true;
      options.desc = "Preview Hunk diff under cursor";
    }
    {
      key = "<leader>hb";
      action = "Gitsigns blame_line { full = true }";
      options.cmd = true;
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
      action = "Gitsigns toggle_current_line_blame";
      options.cmd = true;
      options.desc = "Toggle current line blame";
    }
    {
      key = "<leader>tx";
      action = "Gitsigns toggle_deleted";
      options.cmd = true;
      options.desc = "Toggle visibility of deleted lines";
    }
    {
      key = "<leader>th";
      action = "Gitsigns toggle_linehl";
      options.cmd = true;
      options.desc = "Toggle Hunk Highlighting";
    }
  ];
}
