{ withDefaultKeymapOptions, ... }:

{
  plugins.octo = {
    enable = true;

    settings = {
      default_delete_branch = true;
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>O";
      action = "<cmd>Octo";
      options.desc = "Octo";
    }
  ];
}
