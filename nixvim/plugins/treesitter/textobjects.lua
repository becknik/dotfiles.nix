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

local repeat_move = require "repeatable_move"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()

    local next_error, prev_error = repeat_move.make_repeatable_move_pair(
      function()
        vim.diagnostic.jump {
          count = 1,
          severity = vim.diagnostic.severity.ERROR,
        }
      end,
      function()
        vim.diagnostic.jump {
          count = -1,
          severity = vim.diagnostic.severity.ERROR,
        }
      end
    )
    vim.keymap.set(
      { "n", "x", "o" },
      "]d",
      next_error,
      { desc = "Next Diagnostic Error" }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      "[d",
      prev_error,
      { desc = "Previous Diagnostic Error" }
    )

    local next_warn, prev_warn = repeat_move.make_repeatable_move_pair(
      function()
        vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN }
      end,
      function()
        vim.diagnostic.jump {
          count = -1,
          severity = vim.diagnostic.severity.WARN,
        }
      end
    )
    vim.keymap.set(
      { "n", "x", "o" },
      "]D",
      next_warn,
      { desc = "Next Warning" }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      "[D",
      prev_warn,
      { desc = "Previous Warning" }
    )
  end,
})

local next_spell, prev_spell = repeat_move.make_repeatable_move_pair(
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

local hunk_repeat_next, hunk_repeat_prev = repeat_move.make_repeatable_move_pair(
  function() require("gitsigns").nav_hunk "next" end,
  function() require("gitsigns").nav_hunk "prev" end
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

local todo_next, todo_prev = repeat_move.make_repeatable_move_pair(
  require("todo-comments").jump_next,
  require("todo-comments").jump_prev
)
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
