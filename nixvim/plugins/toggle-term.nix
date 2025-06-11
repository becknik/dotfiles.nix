{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  # https://github.com/akinsho/toggleterm.nvim
  plugins.toggleterm = {
    enable = true;
    settings.size = ''
      function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end
    '';
  };

  plugins.neogit.luaConfig.post = ''
    wk.add {
      { "<leader>t", icon = " ", desc = "Toggle" },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>tt";
      action = "ToggleTerm";
      options.cmd = true;
      options.desc = "ToggleTerm";
    }
    {
      key = "<leader>tv";
      action = "ToggleTerm direction=vertical";
      options.cmd = true;
      options.desc = "ToggleTerm vertical";
    }
    {
      key = "<leader>ta";
      action = "ToggleTermToggleAll";
      options.cmd = true;
      options.desc = "Toggle all Terms";
    }

    {
      key = "<leader>tr";
      action = "ToggleTermSetName";
      options.cmd = true;
      options.desc = "ToggleTerms set name";
    }
    # TODO this mappings is inconsistent to telescope
    {
      key = "<leader>ts";
      action = "TermSelect";
      options.cmd = true;
      options.desc = "Toggle Select";
    }
    {
      key = "<leader>tn";
      action = "TermNew";
      options.cmd = true;
      options.desc = "Toggle New";
    }

    {
      key = "<leader>tv";
      # :ToggleTermSendVisualSelection <T_ID>
      action = "ToggleTermSendVisualSelection";
      mode = mapToModeAbbr [ "visual_select" ];
      options.cmd = true;
      options.desc = "Send Selection to Term";
    }
  ];

  extraConfigLuaPost = ''
    function _G.set_terminal_keymaps()
      vim.keymap.set('t', '<C-x>', [[<C-\><C-n>]], { buffer = 0 })
      -- TODO: might need the index of the current terminal when running multiple
      vim.keymap.set('t', '<C-t>', [[<C-\><C-n><C-w>]], { buffer = 0 })
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  '';
}
