local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

local next_diag_error, prev_diag_error = ts_repeat_move.make_repeatable_move_pair(
  function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR } end,
  function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR } end
)
vim.keymap.set({ "n", "x", "o" }, "]D", next_diag_error, { desc = "Next Diagnostic Error" })
vim.keymap.set({ "n", "x", "o" }, "[D", prev_diag_error, { desc = "Previous Diagnostic Error" })
local next_diag, prev_diag = ts_repeat_move.make_repeatable_move_pair(
  function() vim.diagnostic.jump { count = 1 } end,
  function() vim.diagnostic.jump { count = -1 } end
)
vim.keymap.set({ "n", "x", "o" }, "]d", next_diag, { desc = "Next Diagnostic" })
vim.keymap.set({ "n", "x", "o" }, "[d", prev_diag, { desc = "Previous Diagnostic" })

local next_spell, prev_spell = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd "normal! ]s" end,
  function() vim.cmd "normal! [s" end
)
vim.keymap.set({ "n", "x", "o" }, "]s", next_spell, { desc = "Next Spelling Error" })
vim.keymap.set({ "n", "x", "o" }, "[s", prev_spell, { desc = "Previous Spelling Error" })

local gs = require "gitsigns"
local hunk_repeat_next, hunk_repeat_prev = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
vim.keymap.set({ "n", "x", "o" }, "]h", hunk_repeat_next, { desc = "Next Hunk" })
vim.keymap.set({ "n", "x", "o" }, "[h", hunk_repeat_prev, { desc = "Previous Hunk" })

local todo = require "todo-comments"
local todo_next, todo_prev = ts_repeat_move.make_repeatable_move_pair(todo.jump_next, todo.jump_prev)
vim.keymap.set({ "n", "x", "o" }, "]t", todo_next, { desc = "Next TODO Comment" })
vim.keymap.set({ "n", "x", "o" }, "[t", todo_prev, { desc = "Previous TODO Comment" })
