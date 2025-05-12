{ ... }:

{
  # https://github.com/okuuva/auto-save.nvim/
  plugins.auto-save = {
    enable = true;
    settings.debounce_delay = 10000;
    settings.trigger_events.immediate_save = [
      "BufLeave"
      "WinLeave"
      "FocusLost"
    ];
    settings.trigger_events.defer_save = [ ];
    settings.condition = # lua
      ''
        function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          return fn.getbufvar(buf, "&modifiable") == 1
            and utils.not_in(fn.getbufvar(buf, "&filetype"), {
              "oil"
            })
        end
      '';
  };

}
