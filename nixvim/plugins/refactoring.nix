{ withDefaultKeymapOptions, ... }:

{
  plugins.refactoring = {
    enable = true;
    # TODO doesn't work
    extraOptions = {
      show_success_message = true;
    };
  };

  keymaps = withDefaultKeymapOptions [
    { key = "<leader>re"; action = "<cmd>Refactor extract<cr>"; }
    { key = "<leader>rv"; action = "<cmd>Refactor extract_var<cr>"; }
    { key = "<leader>rf"; action = "<cmd>Refactor extract_to_file<cr>"; }
    { key = "<leader>rb"; action = "<cmd>Refactor extract_block<cr>"; }
    { key = "<leader>rbf"; action = "<cmd>Refactor extract_block_to_file<cr>"; }

    { key = "<leader>ri"; action = "<cmd>Refactor inline_var<cr>"; }
    { key = "<leader>rI"; action = "<cmd>Refactor inline_func<cr>"; }
  ];
}
