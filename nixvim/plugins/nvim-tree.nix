{ helpers, withDefaultKeymapOptions, ... }:

{
  # globals.loaded_netrw = 1;
  # globals.loaded_netrwPluin = 1;

  plugins.nvim-tree = {
    enable = true;

    settings = {
      hijack_cursor = true;

      view = {
        number = true;
        relativenumber = true;
        float = {
          enable = true;

          open_win_config.__raw = ''
            function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * 0.5
              local window_h = screen_h * 0.8
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
                - vim.opt.cmdheight:get()
              return {
                border = 'rounded',
                relative = 'editor',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end
          '';
        };
        width.__raw = ''
          function()
            return math.floor(vim.opt.columns:get() * 0.5)
          end
        '';
      };

      renderer = {
        group_empty = true;
        highlight_git = "name";
        highlight_modified = "name";
        highlight_hidden = "name";

        icons.show = {
          folder = false;
          modified = false;
        };
      };
      ui.confirm.default_yes = true;

      diagnostics.enable = true;
      modified.enable = true;

      notify.absolute_path = false;
      # trash.cmd = "gio trash";

      on_attach = helpers.mkRaw (builtins.readFile ./nvim-tree.lua);
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>T";
      action.__raw = ''
        function()
          local api = require'nvim-tree.api'

          if vim.bo.filetype == "NvimTree" then
            api.tree.toggle()
          else
            api.tree.focus()
          end
        end
      '';
      options.desc = "Toggle Nvim Tree";
    }
  ];
}
