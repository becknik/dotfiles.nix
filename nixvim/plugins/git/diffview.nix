{
  pkgs,
  withDefaultKeymapOptions,
  mapToModeAbbr,
  ...
}:

{
  plugins.diffview = {
    enable = true;

    package = (
      pkgs.vimUtils.buildVimPlugin {
        name = "diffview-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "dlyongemallo";
          repo = "diffview.nvim";
          rev = "c84ba7ae3f0eaa856f4e94807dddf3d767ef9581";
          hash = "sha256-57YPw5VZaRoJvRsnPO2nEZt/0WNALpFRFwTL8Tz+HzY=";
        };
        doCheck = false;
      }
    );

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
            or nil
          vim.cmd("DiffviewFileHistory " .. (path and vim.fn.fnameescape(path) or "%"))
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
