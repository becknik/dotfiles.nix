local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

require('neoclip').setup({
    history = 1000,
    enable_persistent_history = true,
    continuous_sync = false, -- default
    filter = function(data)
      return not all(data.event.regcontents, is_whitespace)
    end,
    on_select = {
      move_to_front = true,
    },
    on_paste = {
      move_to_front = true,
    },
    on_replay = {
      move_to_front = true,
    },
    keys = {
      telescope = {
        i = {
          -- TODO this doesn't work
          move_selection_previous = '<C-p>',
          paste = '<C-P>',
          -- paste_behind = '<C-P>',
          replay = '<C-q>',
          delete = '<C-d>',
          edit = '<C-e>',
        },
        n = {
          paste = 'p',
          paste_behind = 'P',
          replay = 'q',
          delete = 'd',
          edit = 'e',
        },
      },
    },
})