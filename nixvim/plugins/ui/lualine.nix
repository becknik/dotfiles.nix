{ ... }:

{
  autoCmd = [
    {
      event = "BufWinEnter";
      pattern = "oil://*";
      callback.__raw = ''
        function()
          vim.o.laststatus = 2
        end
      '';
    }
    {
      event = "BufWinLeave";
      pattern = "oil://*";
      callback.__raw = ''
        function()
          vim.o.laststatus = 0
        end
      '';
    }
  ];

  plugins.lualine = {
    enable = true;

    luaConfig.pre = ''
      local lualine = require('lualine')
      local base = require('lualine.themes.auto')
      local custom_theme = vim.tbl_deep_extend('force', {}, base)

      for _, mode in ipairs({ 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }) do
        local m = custom_theme[mode]
        if m and m.a then
          m.z = m.z or {}
          local z_bg = m.z.bg or nil
          local z_fg = m.z.fg or nil
          m.z.bg = base[mode].a.bg
          m.z.fg = base[mode].a.fg
          m.a.bg = z_bg
          m.a.fg = z_fg
        end
      end
      vim.o.laststatus = 0
    '';

    settings = {
      options.theme.__raw = "custom_theme";
      extensions = [
        "fzf"
        "man"
        "nvim-dap-ui"
        "trouble"
        "oil"
      ];

      globalstatus = true;

      options.disabled_filetypes.winbar = [
        "codecompanion"
        "toggleterm"
      ];

      sections.__raw = "{}";
      inactive_sections.__raw = "{}";
      winbar = {
        lualine_a = [ "progress" ];
        lualine_b = [
          "fileformat"
          "filetype"
          "location"
        ];
        lualine_c = [
          {
            __unkeyed = "diagnostics";
            separator = "";
          }
          {
            __unkeyed = "%=";
            separator = "";
          }
          {
            # https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#filename-component-options
            __unkeyed = "filename";
            separator = "";
            path = 4;
            symbols = {
              modified = "●";
              readonly = "";
              unnamed = "[No Name]";
            };
          }
        ];

        lualine_x = [
          {
            __unkeyed = "diagnostics";
            sources = [ "nvim_workspace_diagnostic" ];
          }
        ];
        lualine_y = [
          "selectioncount"
          "branch"
          "diff"
        ];
        lualine_z = [
          "mode"
        ];
      };
    };
  };
}
