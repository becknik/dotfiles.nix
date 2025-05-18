{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.bufferline.luaConfig.post = ''
    local wk = require('which-key')
    wk.add {
      { "H", icon = "  " },
      { "L", icon = "  " },

      { "<leader>b", icon = " ", desc = "Buffers" },
      { "<leader>bl", icon = "   " },
      { "<leader>bh", icon = "   " },
      { "<leader>bo", icon = "  󰤼 " },
      { "<leader>bp", icon = "  " },
    }
  '';

  plugins.bufferline = {
    enable = true;

    lazyLoad.enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufNewFile"
    ];

    settings = {
      options = {
        themable = false;
        show_buffer_close_icons = false;
        separator_style = "thick";
        diagnostics = "nvim_lsp";
        numbers = "none"; # ordinal
        max_name_length = 26;

        # max_prefix_length = 24;
        separatorStyle = "thick";
      };
    };
  };

  keymaps = withDefaultKeymapOptions [
    # https://neovim.io/doc/user/windows.html#windows so many shortcuts
    {
      key = "H";
      action = "BufferLineCyclePrev";
      options.cmd = true;
      options.desc = "Focus Left Buffer";
    }
    {
      key = "L";
      action = "BufferLineCycleNext";
      options.cmd = true;
      options.desc = "Focus Right Buffer";
    }

    {
      key = "<leader>bh";
      action = "BufferLineCloseLeft";
      options.cmd = true;
      options.desc = "Close all Left Buffer";
    }
    {
      key = "<leader>bl";
      action = "BufferLineCloseRight";
      options.cmd = true;
      options.desc = "Close all Right Buffer";
    }
    {
      key = "<leader>bo";
      action = "BufferLineCloseOthers";
      options.cmd = true;
      options.desc = "Close all other Buffers";
    }
    {
      key = "<leader>bp";
      action = "BufferLineTogglePin";
      options.cmd = true;
      options.desc = "Pin Buffer";
    }
  ];
}
