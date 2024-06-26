{ withDefaultKeymapOptions, pkgs, ... }:

{
  extraPlugins = with pkgs; [
    (vimUtils.buildVimPlugin {
      name = "my-plugin";
      src = pkgs.fetchFromGitHub {
        owner = "chrishrb";
        repo = "gx.nvim";
        rev = "ea4cc715326a8bd060a450c24c3c9831cdee2f59";
        hash = "sha256-MgRAw3SAYKJ9f0k/kWDBeYIY3eX2KyDmv8mwCLh5A7g=";
      };
    })
  ];

  globals.netrw_nogx = 1;
  extraConfigLuaPre = ''
    	require('gx').setup({ });
  '';

  plugins.oil = {
    enable = true;

    settings = {
      columns = [ "icon" "size" "permissions" ];
      constrain_cursor = "name";
      default_file_explorer = true;
      delete_to_trash = true;
      skip_confirm_for_simple_edits = true; # Selecting a new/moved/renamed file or directory will prompt you to save changes

      view_options = {
        show_hidden = true;
      };

      keymaps = {
        "<c-q>" = "actions.close";
      };
    };
  };

  keymaps = withDefaultKeymapOptions [
    { key = "-"; action = "<cmd>Oil<cr>"; }
    { key = "gx"; action = "<cmd>Browse<cr>"; } # gx-nvim
  ];
}
