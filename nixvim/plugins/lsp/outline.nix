{ pkgs, withDefaultKeymapOptions, ... }:

{
  extraPlugins = with pkgs; [
    vimPlugins.outline-nvim
  ];

  extraConfigLua = ''
    wk.add {
      { "go", icon = "󱉯 " },
      { "gO", icon = "󱉯 " },
      { "<leader>of", icon = "󱉯  󰋱" },
    }

    -- https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#default-options
    require('outline').setup {
      outline_window = {
        auto_close = false,
        show_numbers = true,
        show_numbers_relative = false,
        show_cursorline = true,
        hide_cursor = true,
      },
      auto_width = {
        enabled = true,
      },
      outline_items = {
        show_symbol_lineno = true,
        show_symbol_details = false,
        auto_set_cursor = false,
      },
      keymaps = {
        hover_symbol = 'K',
        toggle_preview = '<C-space>',
        rename_symbol = 'r', -- default
        code_actions = '.',
        fold = { 'h', 'zc' },
        unfold = { 'l', 'zo' },
        fold_toggle = { 'zi', '<tab>' },
        fold_toggle_all = nil,
        fold_all = 'zM',
        unfold_all = 'zR',
        restore_location = '<C-o>',
      },
      symbols = {
        -- TODO: doesn't work
        icon_fetcher = 'lspkind',
      },
    }
  '';

  autoCmd = [
    {
      event = "BufEnter";
      callback.__raw = ''
        function()
          local function count_normal_windows()
            local count = 0
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local config = vim.api.nvim_win_get_config(win)
              if config.relative == "" then -- Non-floating windows
                count = count + 1
              end
            end
            return count
          end

          if vim.bo.filetype == "Outline" and count_normal_windows() == 1 then
            vim.cmd "q!"
          end
        end
      '';
    }
  ];

  keymaps = withDefaultKeymapOptions [
    {
      key = "gO";
      action.__raw = "function() require'outline'.toggle() end";
      options.desc = "Toggle Outline";
    }
    {
      key = "go";
      action.__raw = "function() require'outline'.open() end";
      options.desc = "Outline";
    }

    {
      key = "<leader>of";
      action = "OutlineFollow";
      options.desc = "Outline Follow";
      options.cmd = true;
    }
  ];
}
