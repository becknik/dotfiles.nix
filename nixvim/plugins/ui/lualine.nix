{ helpers, ... }:

{
  plugins.lualine = {
    enable = true;

    settings = {
      extensions = [
        "fzf"
        "man"
        "nvim-dap-ui"
        "trouble"
        "oil"
      ];

      globalstatus = true;

      disabledFiletypes.statusline = [
        "dashboard"
        "alpha"
      ];

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "selectioncount"
          "branch"
          "diff"
        ];
        lualine_c = [
          {
            __unkeyed = "diagnostics";
            sources = [ "nvim_workspace_diagnostic" ];
          }
        ];

        lualine_x = [
          "diagnostics"
          "filetype"
          "fileformat"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };

    };
  };
}
