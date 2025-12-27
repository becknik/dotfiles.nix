{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<C-s>", icon = " 󱡄 " },
      { "<leader>s", icon = " " },
      { "<leader>q", icon = " " },
      { "<leader>Q", icon = " !" },
      { "<leader>w", icon = " " },

      { "<leader>b", icon = "  " },
      { "<leader>B", icon = "  " },
    }
  '';

  plugins.telescope.keymaps = {
    "<leader>b" = {
      action = "buffers theme=ivy sort_mru=true ignore_current_buffer=true";
      options.desc = "Find Buffer";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "L";
      action.__raw = "
        function()
          require'telescope.builtin'.buffers({
            sort_mru = true,
            ignore_current_buffer = true,
            initial_mode = 'normal',

            previewer = false,
            layout_strategy = 'center',
            layout_config = {
              center = {
                height = 14,
              },
            },
            attach_mappings = function(prompt_bufnr, map)
              local actions = require('telescope.actions')

              map('n', 'L', function()
                actions.move_selection_previous(prompt_bufnr)
              end)

              map('n', 'H', function()
                actions.move_selection_next(prompt_bufnr)
              end)

              map('n', 'q', actions.select_default)

              -- Keep default mappings
              return true
            end,
          })
        end
      ";
      options.desc = "LRU Buffer Switcher";
    }

    {
      key = "<leader>q";
      action = "Bdelete";
      options.cmd = true;
      options.desc = "Quit Buffer";
    }
    {
      key = "<leader>Q";
      action = "Bdelete!";
      options.cmd = true;
      options.desc = "Force Quit Buffer";
    }

    {
      key = "<C-s>";
      action = "ConformFormatHunks";
      mode = mapToModeAbbr [
        "normal"
      ];
      options.cmd = true;
      options.desc = "Format Hunks";
    }
    {
      key = "<leader>s";
      action = "write";
      options.cmd = true;
      options.desc = "Write Buffer";
    }

    {
      key = "<leader>w";
      action.__raw = "function() vim.api.nvim_win_close(0, false) end";
      options.desc = "Quit Window";
    }
    {
      key = "<leader>r";
      action = "edit";
      options.cmd = true;
      options.desc = "Reload Buffer from  Disk";
    }
  ];
}
