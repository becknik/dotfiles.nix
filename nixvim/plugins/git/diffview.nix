{ withDefaultKeymapOptions, ... }:

{
  plugins.diffview = {
    enable = true;

    enhancedDiffHl = true;
    view.mergeTool.layout = "diff3_mixed";
  };

  opts.fillchars.diff = " ";
  opts.fillchars.fold = " ";
  opts.fillchars.foldsep = " ";

  plugins.neogit.luaConfig.post = ''
    wk.add {
      { "<leader>go", icon = "" },
      { "<leader>gq", icon = "" },
      { "<leader>gf", icon = "" },
      { "<leader>gn", icon = " " },
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
      key = "<leader>gf";
      action = "DiffviewFileHistory";
      options.cmd = true;
      options.desc = "Open Diffview File history";
    }
    {
      key = "<leader>gn";
      action = "DiffviewFocusFiles";
      options.cmd = true;
      options.desc = "Diffview focus file Navigation";
    }
  ];
}
