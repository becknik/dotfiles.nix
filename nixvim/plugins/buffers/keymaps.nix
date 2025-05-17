{ ... }:

{

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>bf", icon = "  " },
    }
  '';

  plugins.telescope.keymaps = {
    "<leader>bf" = {
      action = "buffers";
      options.desc = "Find Buffer";
    };
  };
}
