{ withDefaultKeymapOptions, ... }:

{
  plugins. toggleterm = {
    enable = true;
    settings.size = 20;
  };

  keymaps = withDefaultKeymapOptions [
    { key = "<leader>gt"; action = "<cmd>ToggleTerm<cr>"; }
    { key = "<leader>gf"; action = "<cmd>ToggleTerm direction=float<cr>"; }
    { key = "<leader>ga"; action = "<cmd>ToggleTermToggleAll<cr>"; }
    { key = "<leader>gs"; action = "<cmd>TermSelect<cr>"; }
    { key = "<leader>gc"; action = "<cmd>ToggleTermSendCurrentLine<cr>"; }
    { key = "<leader>gv"; action = "<cmd>ToggleTermSendVisualSelection<cr>"; }
  ];

  extraConfigLuaPost = ''
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- vim.keymap.set('t', '<c-esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  '';
}
