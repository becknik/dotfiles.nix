{ pkgs, withDefaultKeymapOptions, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [ ecolog-nvim ];

  plugins.blink-cmp.luaConfig.pre = ''
    require('ecolog').setup {
      integrations = {
        nvim_cmp = false,
        blink_cmp = true,
      },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>et";
      action = "EcologSelect";
      options.cmd = true;
      options.desc = "Ecolog Select File";
    }
    {
      key = "<leader>et";
      action = "EcologShellToggle";
      options.cmd = true;
      options.desc = "Ecolog Toggle Shell";
    }
  ];
}
