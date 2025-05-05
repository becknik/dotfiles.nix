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

  plugins.neogit.luaConfig.post = ''
    wk.add {
      { "<leader>G", icon = " " },
      { "<leader>gc", icon = "󰜞" },
      { "<leader>gl", icon = "󰜘" },
      { "<leader>gp", icon = " " },
      { "<leader>gP", icon = " " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>G";
      action = "Neogit kind=floating"; # status & index can't be that messy to not have in displayed in a modal
      options.cmd = true;
      options.desc = "Neogit";
    }

    {
      key = "<leader>gc";
      action = "Neogit commit";
      options.cmd = true;
      options.desc = "Neogit commit";
    }
    {
      key = "<leader>gl";
      action = "Neogit log";
      options.cmd = true;
      options.desc = "Neogit Log";
    }
    {
      key = "<leader>gp";
      action = "Neogit pull";
      options.cmd = true;
      options.desc = "Neogit Pull";
    }
    {
      key = "<leader>gP";
      action = "Neogit push";
      options.cmd = true;
      options.desc = "Neogit Push";
    }
  ];
}
