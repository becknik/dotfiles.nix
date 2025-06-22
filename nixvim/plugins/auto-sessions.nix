{ ... }:

{
  opts.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";

  plugins.auto-session = {
    enable = true;

    settings = {
      args_allow_files_auto_save = true;

      # suppressed_dirs = [
      #   "node_modules"
      #   ".cache"
      #   ".nix"
      #   "/tmp"
      # ];
      # bypass_save_filetypes = [ "oil" ];

      git_use_branch_name = false;
      git_auto_restore_on_branch_change = false;

      lazy_support = true;
      log_level = "debug";

      session_lens.load_on_setup = true;
      session_lens.mappings.delete_session = [
        "n"
        "dd"
      ];
    };
  };

}
