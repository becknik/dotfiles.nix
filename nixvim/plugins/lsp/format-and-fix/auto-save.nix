{ ... }:

{
  extraConfigLuaPre = ''
    function should_write(bufnr)
      -- if not vim.api.nvim_buf_is_loaded(bufnr) then
      --   return false
      -- end

      local buf_name = vim.api.nvim_buf_get_name(bufnr)
      if buf_name == "" then return false end

      -- only save true file-based buffers
      if vim.fn.getbufvar(bufnr, "&buftype") ~= "" then
        return false
      elseif vim.fn.getbufvar(bufnr, "&modifiable") ~= 1 then
        return false
      end

      local utils = require("auto-save.utils.data")
      local shouldBeIncluded = utils.not_in(vim.fn.getbufvar(bufnr, "&filetype"), {
        "oil"
      })
      return shouldBeIncluded
    end
  '';

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
    settings.condition = ''function(bufnr) return should_write(bufnr) end'';
  };

}
