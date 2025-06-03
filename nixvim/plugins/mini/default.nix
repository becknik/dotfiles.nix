{ withDefaultKeymapOptions, ... }:

{
  plugins = {
    mini = {
      enable = true;

      mockDevIcons = true;
      modules = {
        misc = { };
        icons = { };
      };
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>z";
      action.__raw = ''
        function()
          require("mini.misc").zoom()
        end
      '';
      options.desc = "Zoom Window";
    }
  ];
}
