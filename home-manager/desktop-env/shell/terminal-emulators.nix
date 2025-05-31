{ ... }:

{
  programs = {
    alacritty = {
      enable = true;

      settings = {
        window = {
          dimensions = {
            columns = 132;
            lines = 43;
          };
          decorations = "Full"; # "Transparent" "Buttonless" "None" "Full"
          decorations_theme_variant = "Dark"; # "Light" "None"
          opacity = 0.9;
          blur = true;
          dynamic_title = false;
          resize_increments = true; # Prefer resizing window by discrete steps equal to cell dimensions.
          # option_as_alt
        };
        scrolling = {
          history = 25000;
          multiplier = 3; # lines scrolled per increment
        };
        font = {
          normal = {
            family = "Fira Code Nerd Font Mono";
            style = "Retina";
          }; # ligatures aren't supported tho
          # https://github.com/alacritty/alacritty/pull/5696
          bold = {
            style = "SemiBold";
          };
        };
        colors.transparent_background_colors = false; # default
        bell.duration = 200;
        terminal.osc52 = "OnlyCopy"; # "Disabled" | "OnlyCopy" | "OnlyPaste" | "CopyPaste"
        mouse.hide_when_typing = false;
        # TODO `= true` doesn't bings up the mouse visibility again after stopping typing and moving the mouse
        keyboard.bindings = [
          {
            mods = "Control|Shift";
            key = "N";
            action = "CreateNewWindow";
          }
        ];
        env = {
          TERM = "xterm-256color";
        };
      };
    };

    kitty = {
      enable = true;
      font = {
        # macos doesn't detect Nerd font as monospaced (and is actually right)
        # also, kitty doc recommends non-patched font
        name = "Fira Code";
        size = 13;
      };

      settings = {
        scrollback_lines = 5000;
        # accessible when using a separate page for scrollback
        # toggle with kitty_mod + h
        scrollback_pager_history_size = 20; # ~ 10.000 lines per Mb
        wheel_scroll_min_lines = 1;
        touch_scroll_multiplier = 1.0;

        mouse_hide_wait = 1.0; # seconds
        strip_trailing_spaces = "smart";

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
