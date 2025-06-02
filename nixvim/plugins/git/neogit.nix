{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/NeogitOrg/neogit
  plugins.neogit = {
    enable = true;

    settings = {
      console_timeout = 5000; # ms

      disable_hint = true;
      disable_line_numbers = false;
      disable_signs = true;
      fetch_after_checkout = true;
      graph_style = "unicode";
      kind = "replace";
      remember_settings = false; # across sessions
      process_spinner = true;

      integrations = {
        diffview = true;
        telescope = true;
      };

      mappings =
        let
          submit_abort = {
            "<c-c><c-c>" = false;
            "<c-c><c-k>" = false;
            "<C-s>" = "Submit";
          };
          submit_abort_I = {
            ZZ = "Submit";
            ZQ = "Abort";
          };
        in
        {
          commit_editor = submit_abort;
          commit_editor_I = submit_abort // submit_abort_I;
          rebase_editor = submit_abort;
          rebase_editor_I = submit_abort // submit_abort_I;
          status = {
            "o" = "GoToFile";
            "O" = "OpenTree";
          };
        };
    };
  };

  plugins.neogit.luaConfig.post = ''
    wk.add {
      { "<leader>G", icon = " " },
      { "<leader>gc", icon = "󰜞" },
      { "<leader>gl", icon = "󰜘" },
      { "<leader>gp", icon = " " },
      { "<leader>gP", icon = " " },
      { "<leader>gr", icon = " " },
      { "<leader>gZ", icon = " " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>G";
      action = "Neogit"; # status & index can't be that messy to not have in displayed in a modal
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

    {
      key = "<leader>gr";
      action = "Neogit rebase";
      options.cmd = true;
      options.desc = "Neogit Rebase";
    }
    {
      key = "<leader>gZ";
      action = "Neogit stash";
      options.cmd = true;
      options.desc = "Neogit Stash";
    }
  ];
}
