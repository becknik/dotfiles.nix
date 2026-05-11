{ ... }:

{
  programs = {
    kitty = {
      enable = true;
      font = {
        # macos doesn't detect Nerd font as monospaced (and is actually right)
        # also, kitty doc recommends non-patched font
        name = "Fira Code";
        size = 13;
      };

      settings = {
        modify_font = "cell_height +2px";

        scrollback_lines = 5000;
        # accessible when using a separate page for scrollback
        # toggle with kitty_mod + h
        scrollback_pager_history_size = 20; # ~ 10.000 lines per Mb
        wheel_scroll_min_lines = 1;
        touch_scroll_multiplier = 1.0;

        mouse_hide_wait = 1.0; # seconds
        strip_trailing_spaces = "smart";
        clipboard_control = " write-clipboard read-clipboard write-primary read-primary";

        # performance
        repaint_delay = 7; # ms - yields ~144Hz
        input_delay = 1; # ms

        remember_window_size = false;
        initial_window_width = "140c";
        initial_window_height = "48c";

        enable_audio_bell = false;

        update_check_interval = 0;
      };
    };
  };
}
