{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/NeogitOrg/neogit
  plugins.neogit = {
    enable = true;

    settings = {
      disable_line_numbers = true; # default
      disable_signs = true;
      fetch_after_checkout = true;
      # git_services =
      graph_style = "unicode";
      kind = "tab"; # “split”, “vsplit”, “split_above”, “tab”, “floating”, “replace”, “auto”
      use_default_keymaps = true; # default
    };
  };

  # TODO explore neogit - this plugin is way too extensive
  keymaps = withDefaultKeymapOptions [
    { key = "<leader>G"; action = "<cmd>Neogit<cr>"; }
    # { key = "<leader>Gf"; action = "<cmd>Neogit kind=floating<cr>"; }
    # { key = "<leader>Gs"; action = "<cmd>Neogit kind=split<cr>"; }
  ];
}
