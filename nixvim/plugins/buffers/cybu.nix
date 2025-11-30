{ withDefaultKeymapOptions, ... }:

{
  plugins.cybu = {
    enable = true;

    settings = {
      behavior.mode.last_used.view = "rolling";
      display_time = 750;
      exclude = [
        "oil"
      ];
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "L";
      action = "<Plug>(CybuLastusedNext)";
      options.desc = "Next LRU Buffer";
    }
    {
      key = "H";
      action = "<Plug>(CybuLastusedPrev)";
      options.desc = "Prev LRU Buffer";
    }
  ];
}
