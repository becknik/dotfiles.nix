{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.diffview = {
    enable = true;

    settings = {
      enhanced_diff_hl = true;
      view.merge_tool.layout = "diff3_mixed";
    };
  };

  opts.fillchars.diff = " ";
  opts.fillchars.fold = " ";
  opts.fillchars.foldsep = " ";

  plugins.neogit.luaConfig.post = ''
    wk.add {
      { "<leader>go", icon = "" },
      { "<leader>gq", icon = "" },
      { "<leader>gn", icon = " " },
      { "<leader>gh", icon = "  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>go";
      action = "DiffviewOpen";
      options.cmd = true;
      options.desc = "Open Diffview";
    }
    {
      key = "<leader>gq";
      action = "DiffviewClose";
      options.cmd = true;
      options.desc = "Close Diffview";
    }
    {
      key = "<leader>gh";
      action.__raw = ''
        function()
          local path = vim.bo.filetype == "oil"
            and require("oil").get_current_dir()
            or "%"
          vim.cmd("DiffviewFileHistory " .. vim.fn.fnameescape(path))
        end
      '';
      mode = mapToModeAbbr [
        "normal"
        "visual_select"
      ];
      options.desc = "Diffview file History";
    }
    {
      key = "<leader>gH";
      action = "DiffviewFileHistory";
      options.cmd = true;
      options.desc = "Diffview History (global)";
    }
    {
      key = "<leader>gn";
      action = "DiffviewFocusFiles";
      options.cmd = true;
      options.desc = "Diffview focus file Navigation";
    }
  ];
}
