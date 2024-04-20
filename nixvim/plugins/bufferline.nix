{ withDefaultKeymapOptions, ... }:

{
  plugins.bufferline = {
    enable = true;
    themable = false;

    diagnostics = "nvim_lsp";
    numbers = "none"; # ordinal
    maxNameLength = 32;
    maxPrefixLength = 24;
    separatorStyle = "thick";
  };

  keymaps = withDefaultKeymapOptions [
    # https://neovim.io/doc/user/windows.html#windows so many shortcuts
    { key = "H"; action = "<cmd>BufferLineCyclePrev<cr>"; }
    { key = "L"; action = "<cmd>BufferLineCycleNext<cr>"; }

    { key = "<leader>bd"; action = "<cmd>bdelete<cr>"; }
    { key = "<leader>br"; action = "<cmd>BufferLineCloseLeft<cr>"; }
    { key = "<leader>bl"; action = "<cmd>BufferLineCloseRight<cr>"; }
    { key = "<leader>bp"; action = "<cmd>BufferLineTogglePin<cr>"; }
  ];
}
