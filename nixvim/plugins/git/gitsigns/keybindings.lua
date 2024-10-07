function(bufnr)
  local gitsigns = require('gitsigns')

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Stage hunk" })
  map('x', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
  map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "Stage all hunks in buffer" })

  map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
  map('n', '<leader>hh', gitsigns.select_hunk, { desc = "Select hunk" })

  map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Reset (= delete) hunk" })
  map('x', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
  map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "Reset (= delete) all hunks in buffer" })

  map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview hunk diff" })
  map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = "Blame line" })

  map('n', '<leader>hd', gitsigns.diffthis, { desc = "Diff this file" })
  map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = "Diff this file with HEAD~" })

  map('n', '<leader>htb', gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
  map('n', '<leader>htd', gitsigns.toggle_deleted, { desc = "Toggle visibility of deleted lines" })
  map('n', '<leader>htwd', gitsigns.toggle_word_diff, { desc = "Toggle word diff" })
  map('n', '<leader>hth', gitsigns.toggle_linehl, { desc = "Toggle hunk highlighting" })
end
