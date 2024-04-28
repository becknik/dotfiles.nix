{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/akinsho/toggleterm.nvim
  plugins. toggleterm = {
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

  keymaps = withDefaultKeymapOptions [
    { key = "<leader>tt"; action = "<cmd>ToggleTerm<cr>"; }
    { key = "<leader>tT"; action = ":ToggleTerm"; }
    { key = "<leader>tf"; action = "<cmd>ToggleTerm direction=float<cr>"; }
    { key = "<leader>tl"; action = "<cmd>ToggleTerm direction=vertical<cr>"; }
    { key = "<leader>ta"; action = "<cmd>ToggleTermToggleAll<cr>"; }
    { key = "<leader>ts"; action = "<cmd>TermSelect<cr>"; }
    { key = "<leader>tn"; action = "<cmd>ToggleTermSetName<cr>"; }
    { key = "<leader>tc"; action = "<cmd>ToggleTermSendCurrentLine<cr>"; }
    { key = "<leader>tv"; mode = "x"; action = "<cmd>ToggleTermSendVisualSelection<cr>"; }
    { key = "<leader>tv"; mode = "v"; action = "<cmd>ToggleTermSendVisualLines<cr>"; }
  ];

  extraConfigLuaPost = ''
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- vim.keymap.set('t', '<c-esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'qq', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  '';
}
