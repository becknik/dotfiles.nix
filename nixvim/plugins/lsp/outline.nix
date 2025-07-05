{ pkgs, withDefaultKeymapOptions, ... }:

{
  extraPlugins = with pkgs; [
    vimPlugins.outline-nvim
  ];

  extraConfigLua = ''
    wk.add {
      { "go", icon = "󱉯 " },
      { "gO", icon = "󱉯 " },
    }

    -- https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#default-options
    require('outline').setup {
      outline_window = {
        win_width = 25,
        auto_close = false,
        show_numbers = true,
        show_relative_numbers = true,
      },
      outline_items = {
        show_symbol_lineno = true,
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
  ];
}
