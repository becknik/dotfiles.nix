{ helpers, ... }:

{
  plugins.lualine = {
    enable = true;
    extensions = [ "fzf" "man" "nvim-tree" "nvim-dap-ui" "trouble" "toggleterm" ];

    globalstatus = true;
    disabledFiletypes.statusline = [ "dashboard" "alpha" ];

    sections = {
      lualine_a = [ "mode" ];
      lualine_b = [ "branch" "diff" ];
      lualine_c = [ "diagnostic" ];

      # Integrated with Noice
      # source: https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components
      lualine_x = [{
        extraConfig = helpers.mkRaw ''{
              require("noice").api.status.command.get_hl,
              cond = require("noice").api.status.command.has,
              padding = { right = 6 },
            }'';
      }
        "encoding"
        "fileformat"
        "filetype"];
      lualine_y = [ "progress" ];
      lualine_z = [ "location" ];
    };
  };
}
