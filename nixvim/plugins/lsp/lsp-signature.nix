{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.lsp-signature = {
    enable = true;
    settings = {
      hint_prefix = "";
      hint_inline = "right_align"; # inline eol
      hint_scheme = "String"; # ??
      always_trigger = false; # ??
      # latency
      timer_interval = 100;
      toggle_key = "<C-k>";
      # cycle signatures
      select_signature_key = "<C-c>";
      # move cursor into signature help
      move_cursor_key = "<C-i>";
      # move the signature window
      # move_signature_window_key {'<M-k>', '<M-j>', '<M-h>', '<M-l>'}
    };
  };

  keymaps = withDefaultKeymapOptions [
    # {
    #   key = "<C-k>";
    #   action.__raw = "function() vim.lsp.buf.signature_help() end";
    #   modes = mapToModeAbbr [ "insert" ];
    #   options.desc = "Toggle Signature Help";
    # }
  ];
}
