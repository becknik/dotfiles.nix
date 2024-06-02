{ pkgs, helpers, withDefaultKeymapOptions, ... }:

{
  globals.zoxide_use_select = true;

  extraPlugins = with pkgs.vimPlugins; [
    nvim-neoclip-lua
    sqlite-lua

    telescope-zoxide
  ];
  extraConfigLuaPre = builtins.readFile ./neoclip.lua;
  keymaps = withDefaultKeymapOptions [
    { key = "<leader>fy"; action = "<cmd>Telescope neoclip<cr>"; }
    { key = "<leader>cd"; action = "require('telescope').extensions.zoxide.list"; lua = true; }
  ];

  extraConfigLuaPost = "require('telescope').load_extension('zoxide')";

  plugins.telescope = {
    enable = true;

    # https://youtu.be/u_OORAL_xSM?feature=shared&t=442
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true; # replaces the vim.ui.select with telescope
    };

    settings = {
      defaults = {
        file_ignore_patterns = [ "^.git/" ];
        dynamic_preview_title = true; # necessary for neoclip previews

        # https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
        mappings = {
          i = {
            "<c-f>" = helpers.mkRaw "require('telescope.actions').add_selected_to_qflist + require('telescope.actions').open_qflist";

            "<c-k>" = "cycle_history_next";
            "<c-j>" = "cycle_history_prev";
          };
          n = {
            "<c-f>" = helpers.mkRaw "require('telescope.actions').add_selected_to_qflist + require('telescope.actions').open_qflist";

            "<c-k>" = "cycle_history_next";
            "<c-j>" = "cycle_history_prev";

            "<esc>" = "close";
          };
        };
      };
    };

    # https://github.com/nvim-telescope/telescope.nvim/tree/master?tab=readme-ov-file#default-mappings
    # https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
    keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fs" = "grep_string"; # Searches for the string under your cursor or selection in your current working directory
      "<leader>fg" = "live_grep"; # Search for a string in your current working directory and get results live as you type, respects .gitignore

      # vim pickers
      "<leader>fb" = "buffers";
      "<leader>fh" = "help_tags";
      "<leader>fc" = "commands"; # Lists available plugin/user commands and runs them on <cr>
      "<leader>fm" = "marks";
      "<leader>fr" = "registers";
      "<leader>fk" = "keymaps";
      "<leader>fo" = "oldfiles";
      "<leader>f." = "resume";

      # lsp
      "<leader>fd" = "diagnostics";
      "<leader>s" = "lsp_document_symbols";
      "<leader>S" = "lsp_dynamic_workspace_symbols";
      "gci" = "lsp_incoming_calls";
      "gco" = "lsp_outgoing_calls";

      # git
      "<leader>gc" = "git_commits"; # checks them out on <cr>
      "<leader>gb" = "git_branches";
      # Lists all branches with log preview
      # checkout action <cr>
      # track action <c-t>
      # rebase action<c-r>
      # create action <c-a>
      # switch action <c-s>
      # delete action <c-d>
      # merge action <c-y>
    };
  };
}
