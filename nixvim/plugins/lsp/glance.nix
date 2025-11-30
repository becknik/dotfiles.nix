{ withDefaultKeymapOptions, ... }:

{
  plugins.glance = {
    enable = true;

    settings = {
      border.enable = true;
      use_trouble_qf = true;

      mappings.list = {
        "zo".__raw = "require('glance').actions.open_fold";
        "zc".__raw = "require('glance').actions.close_fold";
        "zi".__raw = "require('glance').actions.toggle_fold";
        "<C-q>".__raw = "false";
        "<C-t>".__raw = "require('glance').actions.quickfix";
      };

      hooks = {
        before_open.__raw = ''
          function(results, open, jump, method)
            if method == "definitions" and #results == 1 then
              jump(results[1])
            else
              open()
            end
          end
        '';
      };
    };
  };

  plugins.glance.luaConfig.post = ''
    wk.add {
      { "gt", icon = " " },
      { "gr", icon = "" },
      { "gi", icon = " " },
      { "gd", icon = "" },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "g,";
      action = "Glance resume";
      options.cmd = true;
      options.desc = "Resume";
    }
    {
      key = "gd";
      action = "Glance definitions";
      options.cmd = true;
      options.desc = "Definitions";
    }
    {
      key = "gr";
      action = "Glance references";
      options.cmd = true;
      options.desc = "References";
    }
    {
      key = "gt";
      action = "Glance type_definitions";
      options.cmd = true;
      options.desc = "Type Definitions";
    }
    {
      key = "gi";
      action = "Glance implementations";
      options.cmd = true;
      options.desc = "Implementations";
    }
  ];
}
