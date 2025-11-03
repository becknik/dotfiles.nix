{ withDefaultKeymapOptions, ... }:

{
  opts.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"; # terminal,

  plugins.auto-session = {
    enable = true;

    # NOTE: keep in sync with ./oil.nix if I can solve the issue from rmagatti/auto-session#445 in another way in the future
    luaConfig.pre = ''
      local oil_setup = {
        columns = { "icon", "size", "permissions" },
        default_file_explorer = true,
        delete_to_trash = true,
        keymaps = { ["<C-c>"] = false, q = require("oil.actions").close },
        lsp_file_method = { autosave_changes = true },
        skip_confirm_for_simple_edits = true,
        view_options = { show_hidden = true },
        watch_for_changes = true,
      }
    '';

    settings = {
      args_allow_files_auto_save = true;

      suppressed_dirs = [
        "node_modules"
        ".cache"
        ".nix"
        "/tmp"
        "dl"
        "Downloads"
        "Documents"
        "~"
      ];
      bypass_save_filetypes = [
        "oil"
        "toggleterm"
      ];
      post_restore_cmds = [
        {
          __raw = ''
            function()
              require("oil").setup(oil_setup)
            end
          '';
        }
        "BookmarksInitGlobConfig"
      ];
      no_restore_cmds = [
        {
          __raw = ''
            function()
              require("oil").setup(oil_setup)
            end
          '';
        }
        "BookmarksInitGlobConfig"
      ];

      lazy_support = true;

      session_lens.load_on_setup = true;
      session_lens.mappings.delete_session = [
        "n"
        "dd"
      ];
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>af";
      action = "AutoSession search";
      options.cmd = true;
      options.desc = "Search Sessions";
    }
    {
      key = "<leader>as";
      action = "AutoSession save";
      options.cmd = true;
      options.desc = "Save Session";
    }
    {
      key = "<leader>aD";
      action = "AutoSession delete";
      options.cmd = true;
      options.desc = "Delete current Session";
    }

    {
      key = "<leader>ad";
      action = "AutoSession deletePicker";
      options.cmd = true;
      options.desc = "Delete Autosession";
    }
  ];
}
