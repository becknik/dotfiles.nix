{ withDefaultKeymapOptions, pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    oil-nvim
    gx-nvim
  ];

  # NOTE: keep in sync with ./auto-sessions.nix if I can solve the issue from rmagatti/auto-session#445 in another way in the future
  plugins.oil = {
    enable = false;

    lazyLoad.settings.event = "UIEnter";

    settings = {
      default_file_explorer = true;
      columns = [
        "icon"
        "size"
        "permissions"
      ];
      # constrain_cursor = "name";
      watch_for_changes = true;
      delete_to_trash = true;
      skip_confirm_for_simple_edits = true; # Selecting a new/moved/renamed file or directory will prompt you to save changes

      lsp_file_method.autosave_changes = true;
      view_options = {
        show_hidden = true;
      };

      keymaps = {
        "q" = {
          __raw = "require'oil.actions'.close";
          mode = "n";
        };
        "<C-c>" = false;
      };
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "-";
      action = "Oil";
      options.cmd = true;
      options.desc = "Open Oil";
    }
  ];
}
