local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

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
