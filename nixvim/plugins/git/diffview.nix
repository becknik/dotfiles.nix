{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

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
      action = "DiffviewFileHistory %";
      options.cmd = true;
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
