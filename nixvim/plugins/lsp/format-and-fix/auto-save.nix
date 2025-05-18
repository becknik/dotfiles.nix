{ ... }:

{
  # https://github.com/okuuva/auto-save.nvim/
  plugins.auto-save = {
    enable = true;
    settings.debounce_delay = 5000;
    settings.trigger_events.immediate_save = [
      "BufLeave"
      "WinLeave"
      "FocusLost"
    ];
    settings.trigger_events.defer_save = [
    ];
    settings.condition = # lua
      ''
        function(buf)
          if not buf then return false end

          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name == "" then return false end

          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          -- only save true file-based buffers
          if fn.getbufvar(buf, "&buftype") ~= "" then
            return false
          elseif fn.getbufvar(buf, "&modifiable") ~= 1 then
            return false;
          end

          local shouldBeIncluded = utils.not_in(fn.getbufvar(buf, "&filetype"), {
            "oil"
          })
          return shouldBeIncluded
        end
      '';
  };

}
