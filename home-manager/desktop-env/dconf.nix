{ config, ... }:

let
  default_sidebar_width = 156;
  org_gnome_terminal_legacy_default_profile = {
    allow-bold = true;
    audible-bell = false;
    background-transparency-percent = 15;
    backspace-binding = "auto";
    bold-color-same-as-fg = true;
    bold-is-bright = false;
    cursor-blink-mode = "system";
    cursor-colors-set = true;
    cursor-shape = "block";
    default-size-columns = 132;
    default-size-rows = 42;
    delete-binding = "auto";
    font = "FiraCode Nerd Font 10"; # TODO
    title-mode = "ignore";
    use-system-font = false;
    use-theme-background = false;
    use-theme-colors = false;
    use-theme-transparency = false;
    use-transparent-background = true;
  };
  file_cooser_settings = {
    expand-folders = true;
    location-mode = "path-bar";
    show-hidden = true;
    show-size-column = false;
    show-type-column = false;
    sidebar-width = default_sidebar_width;
    sort-column = "name";
    sort-directories-first = true;
    sort-order = "ascending";
    startup-mode = "cwd";
  };
in {
  dconf.settings = {
    "apps/seahorse/listing".keyrings-selected = [ "openssh:///home/jnnk/.ssh" ];

    "ca/desrt/dconf-editor".show-warning = false;

    "io/github/alainm23/planify" = {
      appearance = "Light";
      dark-mode = false;
      run-in-background = true;
      run-on-startup = true;
      system-appearance = false;
    };

    "io/github/seadve/Kooha" = {
      capture-mode = "monitor-window"; # TODO
      record-delay = 5;
      video-format = "mp4";
      video-framerate = 60;
    };

    "org/gnome/SoundRecorder" = {
      audio-channel = "mono";
      audio-profile = "flac";
    };

    "org/gnome/Weather".locations = "[<(uint32 2, <('Stuttgart', 'EDDS', true, [(0.84968445169480855, 0.16086118520990819)], [(0.85113890437366546, 0.16027939715704839)])>)>]";

    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = false;
      screen-magnifier-enabled = false;
    };

    #"org/gnome/desktop/input-sources".sources = ""; # TODO

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
      enable-animations = false;
      enable-hot-corners = false;
      icon-theme = "Tela-dark";
      show-battery-percentage = true;
      text-scaling-factor = 0.97;
    };

    "org.gnome.desktop.peripherals.keyboard" = { # TODO this is not appied correctly...
      delay = 200;
      remember-numlock-state = false;
      repeat-interval = 25;
    };
    "org/gnome/desktop/peripherals/mouse"= {
      accel-profile = "default";
      speed = 0.1;
    };
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;

    "org/gnome/desktop/privacy" = {
      remember-app-usage = false;
      remember-recent-files = false;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    "org/gnome/desktop/screensaver".lock-delay = 30;

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" "<Alt>F4" ];

      cycle-group = [ "<Alt>Escape" "<Alt>grave" ];
      cycle-group-backward = [ "<Shift><Alt>Escape" "<Shift><Alt>grave" ];
      cycle-windows = [ "<Alt>Tab" ];
      cycle-windows-backward = [ "<Shift><Alt>Tab" ];

      maximize-horizontally = [ "<Super>i" ];
      maximize-vertically = [ "<Super>o" ];
      minimize = [ "<Super>comma" ];
      move-to-center = [ "<Super>C" ];

      move-to-corner-ne = [ "<Super>R" ];
      move-to-corner-nw = [ "<Super>E" ];
      move-to-corner-se = [ "<Super>F" ];
      move-to-corner-sw = [ "<Super>D" ];

      move-to-monitor-down = [ "<Shift><Control><Super>j" ];
      move-to-monitor-left = [ "<Shift><Control><Super>h" ];
      move-to-monitor-right = [ "<Shift><Control><Super>l" ];
      move-to-monitor-up = [ "<Shift><Control><Super>k" ];

      # Never used these
      #move-to-side-e = [ "<Super><Alt>L" ];
      #move-to-side-n = [ "<Super><Alt>K" ];
      #move-to-side-s = [ "<Super><Alt>J" ];
      #move-to-side-w = [ "<Super><Alt>H" ];

      # TODO Collides with the "open multiple instances" shortcuts
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      #move-to-workspace-5 = [ "<Shift><Super>5" ];

      move-to-workspace-down =[ "<Shift><Super>j" ];
      move-to-workspace-last = [ "<Shift><Super>g" ];
      move-to-workspace-left = [ "<Shift><Super>h" ];
      move-to-workspace-right = [ "<Shift><Super>l" ];
      move-to-workspace-up = [ "<Shift><Super>k" ];

      show-desktop = [ "<Super>0" ];

      #switch-applications = [ "<Alt>Escape" ]; # TODO What is this option?
      #switch-applications-backward=['<Shift><Alt>Escape']
      #switch-group=['<Super>grave']
      #switch-group-backward=['<Shift><Super>grave']

      switch-to-workspace-1 = [ "<Control><Super>1" ];
      switch-to-workspace-2 = [ "<Control><Super>2" ];
      switch-to-workspace-3 = [ "<Control><Super>3" ];
      switch-to-workspace-4 = [ "<Control><Super>4" ];
      switch-to-workspace-5 = [ "<Control><Super>5" ];

      switch-to-workspace-down = [ "<Control><Super>j" ];
      switch-to-workspace-last = [ "<Control><Super>e" ];
      switch-to-workspace-left = [ "<Control><Super>h" ];
      switch-to-workspace-right = [ "<Control><Super>l" ];
      switch-to-workspace-up = [ "<Control><Super>k" ];

      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Super>Tab" ];
      toggle-fullscreen = [ "<Super>m" ];
      toggle-maximized = [ "<Super>k" ];
      unmaximize = [ "<Super>j" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      action-middle-click-titlebar = "minimize";
      button-layout = "appmenu:close";
      disable-workarounds = true;
      workspace-names = [ "main0" "main1" "mailing" "messaging" ];
      resize-with-right-button = false;
      visual-bell = true;
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/gnome-system-monitor" = {
      network-in-bits = true;
      network-total-in-bits = false;
      smooth-refresh = false;
      update-interval = 2000;
    };

    "org/gnome/meld" = {
      enable-space-drawer = false;
      highlight-current-line = true;
      highlight-syntax = true;
      prefer-dark-theme = false;
      show-line-numbers = true;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true; # dconf says no schema, but option is set by gnome-tweaks, so...
      center-new-windows = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      experimental-features = [ "scale-monitor-framebuffer" "rt-scheduler" "autoclose-xwayland" ];
      workspaces-only-on-primary = true; # TODO This might be bad?
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>h" ];
      toggle-tiled-right = [ "<Super>l" ];
    };

    "org/gnome/settings-daemon/plugins/color".night-light-enabled = true;

    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [ "<Shift><Super>q" ];
      search = [ "<Super>slash" ];
      terminal = [ "<Super>t" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      ambient-enabled = false; # TODO Whats this?!
      idle-dim = false; # "
      power-saver-profile-on-low-battery = true;
    };

    "org/gnome/shell/extensions/Logo-menu" = { # TODO
      hide-forcequit=true;
      menu-button-icon-click-type=3;
      menu-button-icon-image=23; # 6 = arch linux
      menu-button-icon-size=24;
      show-lockscreen=true;
      show-power-options=true;
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-size = 22;
      tray-pos = "center";
    };

    "org/gnome/shell/extensions/auto-move-windows".application-list = [
      "teams-for-linux.desktop:3"
      "org.mozilla.Thunderbird.desktop:3"
      "io.github.alainm23.planify.desktop:3"
      "io.element.Element.desktop:4"
      "org.telegram.desktop.desktop:4"
      "com.github.eneshecan.WhatsAppForLinux.desktop:4"
      "threema-desktop.desktop:4"
      "discord.desktop:4"
      "signal-desktop.desktop:4"
      #"signal-tray.desktop:4" # TODO
    ];

    "org/gnome/shell/extensions/blur-my-shell".color-and-noise = false;
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur = true;
      style-dialogs = 2;
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = false;
      blur-on-overview = false;
      brightness = 0.0;
      customize = false;
      enable-all = true;
      opacity = 118;
      sigma = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
      customize = false;
      override-background = true;
      style-dash-to-dock = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-panel".blur-original-panel = true;
    "org/gnome/shell/extensions/blur-my-shell/lockscreen".blur = true;
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      customize = false;
      style-components = 1;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      static-blur = true;
      unblur-dynamically = false;
      unblur-in-overview = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/screenshot".blur = true;
    "org/gnome/shell/extensions/blur-my-shell/window-list".blur = false;

    "org/gnome/shell/extensions/dash-to-dock" = {
      animation-time = 0.05;
      apply-custom-theme = false;
      autohide-in-fullscreen = true;
      background-opacity = 0.8;
      click-action = "cycle-windows";
      custom-background-color = false;
      custom-theme-running-dots-border-color = "rgb(255,255,255)";
      custom-theme-running-dots-color = "rgb(255,255,255)";
      custom-theme-shrink = false;
      customize-alphas = false;
      dash-max-icon-size = 42;
      disable-overview-on-startup = false;
      dock-fixed = false;
      dock-position = "LEFT";
      extend-height = false;
      height-fraction = 0.9;
      hide-delay = 0.5;
      hot-keys = false; # TODO ?
      hotkeys-overlay = false;
      hotkeys-show-dock = false;
      icon-size-fixed = false;
      intellihide = false;
      intellihide-mode = "ALWAYS_ON_TOP";
      isolate-monitors = false;
      isolate-workspaces = false;
      max-alpha = 0.8;
      middle-click-action = "launch";
      multi-monitor = true;
      pressure-threshold = 100.0;
      preview-size-scale = 0.0;
      require-pressure-to-show = false;
      running-indicator-dominant-color = false;
      running-indicator-style = "DASHES";
      scroll-action = "switch-workspace";
      scroll-to-focused-application = true;
      shift-click-action = "launch";
      shift-middle-click-action = "launch";
      shortcut = ["<Super>q"]; # TODO ?
      shortcut-text = "<Super>q"; # "
      shortcut-timeout = 0.5;
      show-apps-at-top = false;
      show-delay = 1.3877787807814457e-17; # TODO ??
      show-dock-urgent-notify = true;
      show-favorites = true;
      show-mounts = false;
      show-mounts-network = true;
      show-running = true;
      show-show-apps-button = false;
      show-trash = true;
      show-windows-preview = false;
      transparency-mode = "DYNAMIC";
      unity-backlit-items = false;
      workspace-agnostic-urgent-windows = false;
    };

    "org/gnome/shell/extensions/espresso" = {
      enable-docked = true;
      has-battery = true;
      user-enabled = false;
    };

    "org/gnome/shell/extensions/gtile" = {
      animation = false;
      auto-close-keyboard-shortcut = true;
      grid-sizes = "5x5";
      global-presets = false;
      moveresize-enabled = false;

      preset-resize-1 = [ "1" ];
      preset-resize-2 = [ "2" ];
      preset-resize-3 = [ "3" ];
      preset-resize-4 = [ "4" ];

      resize1 = "5x5 2:2 4:4, 1:1 3:3, 3:1 5:3, 3:3 5:5, 1:3 3:5";
      resize2 = "5x5 1:1 4:4, 2:1 5:4, 2:2 5:5, 1:2 4:5";
      resize3 = "5x5 1:1 2:2, 4:1 5:2, 4:4 5:5, 1:4 2:5";
      resize4 = "5x5 1:1 2:3, 4:1 5:3, 4:3 5:5, 1:3 2:5";

      show-grid-lines = true;
      show-icon = true;
      target-presets-to-monitor-of-mouse = false;
      theme = "Classic";
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = false;
      activities-button-icon-monochrome = false;
      activities-button-label = false;
      aggregate-menu = true;
      alt-tab-icon-size = 0;
      alt-tab-small-icon-size = 0;
      alt-tab-window-preview-size = 0;
      animation = 0;
      app-menu = false;
      app-menu-icon = false;
      app-menu-label = false;
      background-menu = true;
      clock-menu-position = 2;
      clock-menu-position-offset = 0;
      dash = true;
      dash-icon-size = 0;
      double-super-to-appgrid = false;
      events-button = false;
      gesture = true;
      hot-corner = true;
      keyboard-layout = true;
      looking-glass-height = 0;
      looking-glass-width = 0;
      notification-banner-position = 2;
      osd = true;
      osd-position = 0;
      panel = false;
      panel-arrow = false;
      panel-button-padding-size = 0;
      panel-corner-size = 1;
      panel-icon-size = 0;
      panel-in-overview = true;
      panel-indicator-padding-size = 0;
      panel-notification-icon = true;
      power-icon = true;
      ripple-box = false;
      search = true;
      show-apps-button = false;
      show-prefs-intro = false;
      startup-status = 1;
      theme = true;
      top-panel-position = 1;
      type-to-search = true;
      window-demands-attention-focus = true;
      window-menu-take-screenshot-button = true;
      window-picker-icon = true;
      window-preview-caption = true;
      workspace = true;
      workspace-background-corner-size = 0;
      workspace-popup = true;
      workspace-switcher-should-show = false;
      workspace-switcher-size = 10;
      workspace-wrap-around = false;
      workspaces-in-app-grid = false;
    };

# org/gnome/shell/extensions/quick-settings-tweaks # I'm abadining this one due to the errors caused by it
#datemenu-fix-weather-widget=false
#datemenu-remove-notifications=true
#input-always-show=true
#input-show-selected=true
#list-buttons='[{"name":"SystemItem","label":null,"visible":true},{"name":"Notifications","label":null,"visible":false},{"name":"OutputStreamSlider","label":null,"visible":false},{"name":"InputStreamSlider","label":null,"visible":false},{"name":"St_BoxLayout","label":null,"visible":true},{"name":"BrightnessItem","label":null,"visible":true},{"name":"NMWiredToggle","label":null,"visible":true},{"name":"NMWirelessToggle","label":null,"visible":true},{"name":"NMModemToggle","label":null,"visible":true},{"name":"NMBluetoothToggle","label":null,"visible":true},{"name":"NMVpnToggle","label":null,"visible":true},{"name":"BluetoothToggle","label":"Bluetooth","visible":false},{"name":"PowerProfilesToggle","label":"Power Mode","visible":false},{"name":"NightLightToggle","label":"Night Light","visible":true},{"name":"DarkModeToggle","label":"Dark Style","visible":true},{"name":"RfkillToggle","label":"Airplane Mode","visible":false},{"name":"RotationToggle","label":"Auto Rotate","visible":false},{"name":"ServiceToggle","label":"GSConnect","visible":true},{"name":"DndQuickToggle","label":"Do Not Disturb","visible":true},{"name":"BackgroundAppsToggle","label":null,"visible":false},{"name":"MediaSection","label":null,"visible":false}]'
#notifications-enabled=true
#notifications-hide-when-no-notifications=true
#notifications-integrated=true
#notifications-position='top'
#output-show-selected=true
#volume-mixer-check-description=false
#volume-mixer-position='top'

    "org/gnome/shell/extensions/rounded-window-corners" = {
      black-list = [ "gnome-terminal-server" ];
      border-color= [ 0.5 0.5 0.5 1.0 ]; # TODO this was a ( ... ) before
      border-width = 0;
      enable-preferences-entry = true;
      focused-shadow = "{'vertical_offset': 4, 'horizontal_offset': 0, 'blur_offset': 28, 'spread_radius': 0, 'opacity': 80}";
      global-rounded-corner-settings = "{'padding': <{'left': <uint32 0>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <true>, 'fullscreen': <false>}>, 'border_radius': <uint32 19>, 'smoothing': <uint32 0>, 'enabled': <true>}";
      settings-version = 5;
      skip-libadwaita-app = true;
      skip-libhandy-app = true;
      unfocused-shadow = "{'vertical_offset': 2, 'horizontal_offset': 0, 'blur_offset': 12, 'spread_radius': -1, 'opacity': 65}";
    };

    "org/gnome/shell/extensions/vitals" = {
      battery-slot = 1;
      fixed-widths = true;
      hide-icons = false;
      hide-zeros = true;
      hot-sensors = [
        "_memory_usage_"
        "_system_load_15m_"
        "_system_load_1m_"
        "_processor_process_time_"
        "_processor_usage_"
        "__temperature_avg__"
        "__temperature_max__"
        "__network-rx_max__"
        "__network-tx_max__"
      ];
      memory-measurement = 0;
      position-in-panel = 0;
      show-battery = false;
      show-fan = false;
      show-storage = false;
      show-voltage = false;
      update-time = 5;
      use-higher-precision = true;
    };

    "org/gnome/shell/weather".automatic-location = true;

    "org/gnome/simple-scan" = { # TODO makes this sense?
      document-type = "text";
      jpeg-quality = 100;
      page-side = "front";
      photo-dpi = 600;
      postproc-enabled = false;
      save-directory = "file:///home/jnnk/dl/";
      text-dpi = 600;
    };

    "org/gnome/system/location".enabled = true;

    "org/gnome/terminal/legacy" = {
      tab-position = "bottom";
      theme-variant = "dark";
    };

    "org/gnome/terminal/legacy/profiles:" = {
      default = "4a3fbad7-a54d-4910-b51a-808fea7e70e2";
      list = [ "4a3fbad7-a54d-4910-b51a-808fea7e70e2" "dd180816-99e9-4947-bd75-2af5159e839b" ];
    };

    "org/gnome/terminal/legacy/profiles:/:4a3fbad7-a54d-4910-b51a-808fea7e70e2" = ( # Gogh's 'Desert' theme
      org_gnome_terminal_legacy_default_profile // {
        background-color = "#333333333333";
        bold-color = "#FFFFFFFFFFFF";
        cursor-background-color = "#FFFFFFFFFFFF";
        cursor-foreground-color = "#333333333333";
        foreground-color = "#FFFFFFFFFFFF";
        palette = [
          "#4D4D4D4D4D4D"
          "#FFFF2B2B2B2B"
          "#9898FBFB9898"
          "#F0F0E6E68C8C"
          "#CDCD85853F3F"
          "#FFFFDEDEADAD"
          "#FFFFA0A0A0A0"
          "#F5F5DEDEB3B3"
          "#555555555555"
          "#FFFF55555555"
          "#5555FFFF5555"
          "#FFFFFFFF5555"
          "#8787CECEFFFF"
          "#FFFF5555FFFF"
          "#FFFFD7D70000"
          "#FFFFFFFFFFFF"
        ];
        visible-name = "Desert";
      }
    );

    "org/gnome/terminal/legacy/profiles:/:dd180816-99e9-4947-bd75-2af5159e839b" = ( # Gogh's 'Panda' theme
      org_gnome_terminal_legacy_default_profile // {
        background-color = "#1D1D1E1E2020";
        bold-color = "#F0F0F0F0F0F0";
        cursor-background-color = "#F0F0F0F0F0F0";
        cursor-foreground-color = "#1D1D1E1E2020";
        foreground-color = "#F0F0F0F0F0F0";
        palette = [
          "#1F1F1F1F2020"
          "#FBFB05055A5A"
          "#2626FFFFD4D4"
          "#FDFDAAAA5A5A"
          "#5C5C9F9FFFFF"
          "#FCFC5959A6A6"
          "#2626FFFFD4D4"
          "#F0F0F0F0F0F0"
          "#5C5C63637070"
          "#FBFB05055A5A"
          "#2626FFFFD4D4"
          "#FEFEBEBE7E7E"
          "#5555ADADFFFF"
          "#FDFD9595D0D0"
          "#2626FFFFD4D4"
          "#F0F0F0F0F0F0"
        ];
        visible-name = "Panda";
      }
    );

    "org/gtk/settings/file-chooser" = file_cooser_settings;
    "org/gtk/gtk4/settings/file-chooser" = file_cooser_settings;

    "org/virt-manager/virt-manager/details".show-toolbar = true;
    "org/virt-manager/virt-manager/paths".image-default = "${config.home.homeDirectory}/vm";
  };
}