{ ... }:

{
  plugins = {
    gitsigns = {
      enable = true;

      gitPackage = null;
      settings = {
        attach_to_untracked = true;
        current_line_blame = false; # default
        current_line_blame_opts = {
          delay = 250;
          ignore_whitespace = true;
          virt_text_pos = "eol"; # default; “eol”, “overlay”, “right_align”
          # virt_text_priority = 100;
        };
        # current_line_blame_formatter
        # max_file_length
        numhl = true;
        diff_opts = {
          algorithm = "minimal"; # default; “myers”, “minimal”, “patience”
          ignore_whitespace_change = false;
          # Ignore changes in amount of white space. It should ignore adding trailing white space, but not leading white space.
          ignore_whitespace_change_at_eol = false;
          indent_heuristic = false; # default
          internal = true;
          # linematch = true; # Enable second-stage diff on hunks to align lines. Requires internal=true.
        };

        signs = {
          add = { text = "┃"; };
          change = { text = "󰇝"; }; # 󰇝󱋱
          delete.show_count = true;
          changedelete.show_count = true;
        };
      };
      extraOptions.on_attach = ''
        function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)
          map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hu', gitsigns.undo_stage_hunk)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
          map('n', '<leader>td', gitsigns.toggle_deleted)
        end
      '';
    };
  };
}
