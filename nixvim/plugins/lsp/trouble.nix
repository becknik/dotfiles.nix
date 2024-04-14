{ ... }:

{
  # https://github.com/folke/trouble.nvim/tree/dev
  plugins.trouble = {
    enable = true;

    settings = {
      auto_fold = true;
      height = 10; # default
      width = 33;
      mode = "workspace_diagnostics"; # “workspace_diagnostics”, “document_diagnostics”, “quickfix”, “lsp_references”, “loclist”
      padding = true; # default
      position = "bottom"; # “bottom”, “top”, “left”, “right”
      win_config = { border = "single"; };

      signs = { }; # TODO use the ones from cmp?

      action_keys = {
        close_folds = [ "zM" "zc" ]; # TODO
        open_folds = [ "zR" "zo" ]; # TODO
        jump = [ "<cr>" "<tab>" ]; # default
        jump_close = [ "o" ]; # default
        previous = "k"; # default
        next = "j"; # default
        preview = "p"; # default
        toggle_preview = "P"; # default
        refresh = "r"; # default

        toggle_mode = "m"; # default

        # open_split open_tab open_vsplit
      };
    };
  };
}
