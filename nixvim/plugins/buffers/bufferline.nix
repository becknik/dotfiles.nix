{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.bufferline.luaConfig.post = ''
    local wk = require('which-key')
    wk.add {
      { "<leader>b", icon = " ", desc = "Buffers" },
      { "<leader>bd", icon = " " },
      { "<leader>bw", icon = " " },
      { "<leader>bl", icon = " " },
      { "<leader>bh", icon = " " },
      { "<leader>bp", icon = "  " },
      { "<C-s>", icon = "", desc = "Save Buffer" },
      { "H", icon = "", desc = "Focus Left Buffer" },
      { "L", icon = "", desc = "Focus Right Buffer" },
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
      highlights.buffer_selected.underline = true;

      options = {
        themable = false;
        show_buffer_close_icons = false;
        separator_style = "thick";
        diagnostics = "nvim_lsp";
        numbers = "none"; # ordinal
        max_name_length = 26;

        # max_prefix_length = 24;
        separatorStyle = "thick";

        groups = {
          items = [
            { __raw = "require('bufferline.groups').builtin.ungrouped"; }
            {
              name = "Tests";
              priority = 2;
              highlight = {
                italic = true;
              };
              icon = " ";
              matcher.__raw = ''
                function(buf)
                  return buf.name:match('test')
                end
              '';
            }
            {
              name = "Docs";
              highlight = {
                underdashed = true;
              };
              matcher.__raw = ''
                function(buf)
                  return buf.name:match('%.md')
                end
              '';
            }
          ];
        };
      };
    };
  };

  keymaps = withDefaultKeymapOptions [
    # https://neovim.io/doc/user/windows.html#windows so many shortcuts
    {
      key = "H";
      action = "BufferLineCyclePrev";
      options.cmd = true;
    }
    {
      key = "L";
      action = "BufferLineCycleNext";
      options.cmd = true;
    }

    {
      key = "<leader>bd";
      action = "bdelete";
      options.cmd = true;
      options.desc = "Quit Buffer";
    }
    {
      key = "<leader>bw";
      action = "bdelete!";
      options.cmd = true;
      options.desc = "Force Quit Buffer";
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
      key = "<leader>bw";
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

    {
      key = "<C-s>";
      action = ":write";
      mode = mapToModeAbbr [
        "normal"
        "insert"
      ];
      options.cmd = true;
      options.desc = "Write Buffer";
    }
  ];
}
