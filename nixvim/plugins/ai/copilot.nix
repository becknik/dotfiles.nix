{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.copilot-lua = {
    enable = true;

    settings.server_opts_overrides = {
      settings.advanced = {
        listCount = 10;
        inlineSuggestCount = 3;
      };
    };
  };

  plugins.copilot-lua.luaConfig.post = ''
    wk.add {
      { "<C-c>", desc = "Copilot", mode = { "n", "i" } },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<C-c>";
      action.__raw = ''
        function()
          vim.schedule(function()
            wk.show { keys = "<C-c>" }
          end)
        end
      '';
      mode = mapToModeAbbr [
        "insert"
      ];
    }

    {
      key = "<C-c>t";
      action.__raw = "function() require'copilot.panel'.toggle() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Toggle Copilot Panel";
    }
    {
      key = "<C-c>oa";
      action.__raw = "function() require'copilot.panel'.accept() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Panel Accept";
    }
    {
      key = "<C-c>or";
      action.__raw = "function() require'copilot.panel'.refresh() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Panel Refresh";
    }
    {
      key = "<C-c>on";
      action.__raw = "function() require'copilot.panel'.jump_next() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Panel Next";
    }
    {
      key = "<C-c>op";
      action.__raw = "function() require'copilot.panel'.jump_prev() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Panel Prev";
    }

    {
      key = "<C-c>c";
      action.__raw = "function() require'copilot.suggestion'.toggle_auto_trigger() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Toggle Copilot Auto Trigger";
    }
    {
      key = "<C-c>n";
      action.__raw = "function() require'copilot.suggestion'.next() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Next";
    }
    {
      key = "<C-c>p";
      action.__raw = "function() require'copilot.suggestion'.prev() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Previous";
    }
    {
      key = "<C-c>l";
      action.__raw = "function() require'copilot.suggestion'.accept_line() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Accept Line";
    }
    {
      key = "<C-c>a";
      action.__raw = "function() require'copilot.suggestion'.accept() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Accept";
    }
    {
      key = "<tab>";
      action.__raw = ''
        function()
          if require'copilot.suggestion'.is_visible() then
            require'copilot.suggestion'.accept()
          end
        end'';
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Accept";
    }
    {
      key = "<C-c>w";
      action.__raw = "function() require'copilot.suggestion'.accept_word() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Accept Word";
    }
    {
      key = "<C-c>d";
      action.__raw = "function() require'copilot.suggestion'.dismiss() end";
      mode = mapToModeAbbr [
        "insert"
        "normal"
      ];
      options.desc = "Copilot Dismiss";
    }
  ];
}
