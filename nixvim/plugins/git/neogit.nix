{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/NeogitOrg/neogit
  plugins.neogit = {
    enable = true;


    settings =
      let
        submit_abort = {
          "<c-c><c-c>" = null;
          "<c-c><c-k>" = null;
          ZZ = "Submit";
          ZQ = "Abort";
        };
      in
      {
        console_timeout = 1000; # threshold to open the console on command execution

        disable_line_numbers = false;
        disable_signs = true;
        fetch_after_checkout = true;
        graph_style = "unicode";
        kind = "replace";
        remember_settings = false; # across sessions

        integrations = {
          diffview = true;
          telescope = true;
        };

        commit_editor = submit_abort;
        commit_editor_i = submit_abort;
        rebase_editor = submit_abort;
        rebase_editor_i = submit_abort;
      };
  };

  keymaps = withDefaultKeymapOptions [
    { key = "<leader>G"; action = "<cmd>Neogit<cr>"; }
    { key = "<leader>gf"; action = "<cmd>Neogit kind=floating<cr>"; }
  ];
}
