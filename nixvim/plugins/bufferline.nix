{ ... }:

{
  plugins.bufferline = {
    enable = true;

    diagnostics = "nvim_lsp";
    numbers = "ordinal";
    maxNameLength = 32;
    maxPrefixLength = 24;
    separatorStyle = "thick";
  };

  keymaps = [
    { key = "H"; action = "<cmd>BufferLineCyclePrev<CR>"; }
    { key = "L"; action = "<cmd>BufferLineCycleNext<CR>"; }

    { key = "<leader>bd"; action = "<cmd>bdelete<CR>"; }
    { key = "<leader>br"; action = "<cmd>BufferLineCloseLeft<CR>"; }
    { key = "<leader>bl"; action = "<cmd>BufferLineCloseRight<CR>"; }
    { key = "<leader>bp"; action = "<cmd>BufferLineTogglePin<CR>"; }
  ];
}
