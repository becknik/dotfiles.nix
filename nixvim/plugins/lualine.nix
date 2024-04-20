{ ... }:

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

      lualine_x = [ "encoding" "fileformat" "filetype" ];
      lualine_y = [ "progress" ];
      lualine_z = [ "location" ];
    };
  };
}
