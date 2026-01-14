local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set(
  { "n", "x", "o" },
  "f",
  ts_repeat_move.builtin_f_expr,
  { expr = true }
)
vim.keymap.set(
  { "n", "x", "o" },
  "F",
  ts_repeat_move.builtin_F_expr,
  { expr = true }
)
vim.keymap.set(
  { "n", "x", "o" },
  "t",
  ts_repeat_move.builtin_t_expr,
  { expr = true }
)
vim.keymap.set(
  { "n", "x", "o" },
  "T",
  ts_repeat_move.builtin_T_expr,
  { expr = true }
)

-- https://github.com/kiyoon/dotfiles/blob/master/nvim/lua/kiyoon/ts_textobjs_main_extended.lua
local set_last_move = function(move_fn, opts, ...)
  if type(move_fn) ~= "function" then
    vim.notify(
      "nvim-treesitter-textobjects: move_fn has to be a function but got "
        .. vim.inspect(move_fn),
      vim.log.levels.ERROR
    )
    return false
  end

  if type(opts) ~= "table" then
    vim.notify(
      "nvim-treesitter-textobjects: opts has to be a table but got "
        .. vim.inspect(opts),
      vim.log.levels.ERROR
    )
    return false
  elseif opts.forward == nil then
    vim.notify(
      "nvim-treesitter-textobjects: opts has to include a `forward` boolean but got "
        .. vim.inspect(opts),
      vim.log.levels.ERROR
    )
    return false
  end

  ts_repeat_move.last_move =
    { func = move_fn, opts = vim.deepcopy(opts), additional_args = { ... } }
  return true
end

local make_repeatable_move_pair = function(forward_move_fn, backward_move_fn)
  local general_repeatable_move_fn = function(opts, ...)
    if opts.forward then
      forward_move_fn(...)
    else
      backward_move_fn(...)
    end
  end

  local repeatable_forward_move_fn = function(...)
    set_last_move(general_repeatable_move_fn, { forward = true }, ...)
    forward_move_fn(...)
  end

  local repeatable_backward_move_fn = function(...)
    set_last_move(general_repeatable_move_fn, { forward = false }, ...)
    backward_move_fn(...)
  end

  return repeatable_forward_move_fn, repeatable_backward_move_fn
end

local next_diag_error, prev_diag_error = make_repeatable_move_pair(
  function()
    vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
  end,
  function()
    vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
  end
)
vim.keymap.set(
  { "n", "x", "o" },
  "]d",
  next_diag_error,
  { desc = "Next Diagnostic Error" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[d",
  prev_diag_error,
  { desc = "Previous Diagnostic Error" }
)
local next_diag, prev_diag = make_repeatable_move_pair(
  function() vim.diagnostic.jump { count = 1 } end,
  function() vim.diagnostic.jump { count = -1 } end
)
vim.keymap.set({ "n", "x", "o" }, "]D", next_diag, { desc = "Next Diagnostic" })
vim.keymap.set(
  { "n", "x", "o" },
  "[D",
  prev_diag,
  { desc = "Previous Diagnostic" }
)

local next_spell, prev_spell = make_repeatable_move_pair(
  function() vim.cmd "normal! ]s" end,
  function() vim.cmd "normal! [s" end
)
vim.keymap.set(
  { "n", "x", "o" },
  "]s",
  next_spell,
  { desc = "Next Spelling Error" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[s",
  prev_spell,
  { desc = "Previous Spelling Error" }
)

local gs = require "gitsigns"
local hunk_repeat_next, hunk_repeat_prev = make_repeatable_move_pair(
  function() gs.nav_hunk "next" end,
  function() gs.nav_hunk "prev" end
)
vim.keymap.set(
  { "n", "x", "o" },
  "]h",
  hunk_repeat_next,
  { desc = "Next Hunk" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[h",
  hunk_repeat_prev,
  { desc = "Previous Hunk" }
)

local todo = require "todo-comments"
local todo_next, todo_prev =
  make_repeatable_move_pair(todo.jump_next, todo.jump_prev)
vim.keymap.set(
  { "n", "x", "o" },
  "]t",
  todo_next,
  { desc = "Next TODO Comment" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[t",
  todo_prev,
  { desc = "Previous TODO Comment" }
)
