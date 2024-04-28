{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/folke/trouble.nvim
  plugins.trouble = {
    enable = true;

    settings = {
      auto_fold = true;
      height = 10; # default
      mode = "workspace_diagnostics"; # “workspace_diagnostics”, “document_diagnostics”, “quickfix”, “lsp_references”, “loclist”
      padding = true; # default
      position = "bottom"; # “bottom”, “top”, “left”, “right”
      win_config = { border = "single"; };

      use_diagnostic_signs = true;

      action_keys = {
        close_folds = [ "zM" "zc" ]; # TODO
        open_folds = [ "zR" "zo" ]; # TODO
        help = [ "?" "g?" ];
      };
    };
  };
  keymaps = withDefaultKeymapOptions [
    { key = "<leader>xt"; action = "<cmd>TroubleToggle<cr>"; }
    { key = "<leader>xw"; action = "<cmd>TroubleToggle workspace_diagnostics<cr>"; }
    { key = "<leader>xd"; action = "<cmd>TroubleToggle document_diagnostics<cr>"; }
    { key = "<leader>xq"; action = "<cmd>TroubleToggle quickfix<cr>"; }
    { key = "<leader>xl"; action = "<cmd>TroubleToggle loclist<cr>"; }
  ];
}
