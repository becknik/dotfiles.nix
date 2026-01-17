{ withDefaultKeymapOptions, ... }:

{
  plugins.visual-multi = {
    enable = true;

    # https://nix-community.github.io/nixvim/plugins/visual-multi/settings.html
    # https://github.com/mg979/vim-visual-multi/wiki/Quick-start
    settings = {
      add_cursor_at_pos_no_mappings = 1;
      default_mappings = 1;
      maps = {
        "Add Cursor Down" = "<M-Down>";
        "Add Cursor Up" = "<M-Up>";
        "Mouse Cursor" = "<M-LeftMouse>";
        "Mouse Word" = "<M-RightMouse>";
        "Select All" = "<C-M-n>";
      };
      mouse_mappings = 1;
    };
  };

  extraConfigLuaPost = ''
    wk.add {
      { "<leader>v", icon = "VM" },
    }
  '';
  # https://github.com/mg979/vim-visual-multi/blob/master/autoload/vm/plugs.vim
  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>va";
      action = "<Plug>(VM-Select-All)";
      options.desc = "VM: Select All";
    }
    {
      key = "<leader>vr";
      action = "<Plug>(VM-Start-Regex-Search)";
      options.desc = "VM: Start Regex Search";
    }
    {
      key = "<leader>vc";
      action = "<Plug>(VM-Add-Cursor-At-Pos)";
      options.desc = "VM: Add cursor at position";
    }
    {
      key = "<leader>vt";
      action = "<Plug>(VM-Toggle-Mappings)";
      options.desc = "VM: Toggle";
    }
  ];
}
