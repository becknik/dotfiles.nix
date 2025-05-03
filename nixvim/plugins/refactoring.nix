{ withDefaultKeymapOptions, ... }:

{
  plugins.refactoring = {
    enable = true;
    # TODO doesn't work
    settings.show_success_message = true;
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>ee";
      action = "<cmd>Refactor extract<cr>";
    }
    {
      key = "<leader>ev";
      action = "<cmd>Refactor extract_var<cr>";
    }
    {
      key = "<leader>ef";
      action = "<cmd>Refactor extract_to_file<cr>";
    }
    {
      key = "<leader>eb";
      action = "<cmd>Refactor extract_block<cr>";
    }
    {
      key = "<leader>ebf";
      action = "<cmd>Refactor extract_block_to_file<cr>";
    }

    { key = "<leader>ei"; action = "<cmd>Refactor inline_var<cr>"; }
    { key = "<leader>eI"; action = "<cmd>Refactor inline_func<cr>"; }
  ];
}
