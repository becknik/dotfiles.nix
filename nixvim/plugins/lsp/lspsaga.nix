{ ... }:

{
  # TODO sort out the default values
  # TODO is https://github.com/stevearc/dressing.nvim a better alternative?
  # TODO is telescope a better replacement for this plugin?

  # https://nix-community.github.io/nixvim/plugins/lspsaga/index.html
  # https://nvimdev.github.io/lspsaga/
  plugins.lspsaga = {
    enable = true;

    beacon.enable = true;
    beacon.frequency = 7;

    callhierarchy = {
      layout = "float";

      keys = {
        close = "<c-c>k";
        edit = "e";
        quit = "q";
        shuttle = "[w";
        split = "i";
        tabe = "t";
        toggleOrReq = "u";
        vsplit = "s";
      };
    };

    codeAction = {
      extendGitSigns = true;
      onlyInCursor = true;

      keys = {
        exec = "<cr>";
        quit = [ "<ESC>" "q" ];
      };
    };

    definition = {
      height = .5;
      width = .6;

      keys = {
        close = "<c-c>k";
        edit = "<c-c>o";
        quit = "q";
        split = "<c-c>i";
        tabe = "<c-c>t";
        vsplit = "<c-c>v";
      };
    };

    # :Lspsaga diagnostic_jump_next, :Lspsaga diagnostic_jump_prev, :Lspsaga show_buf_diagnostics
    # TODO not showing the action lines?
    diagnostic = {
      borderFollow = true;
      diagnosticOnlyCurrent = false;
      extendRelatedInformation = false;
      jumpNumShortcut = true;
      maxHeight = .6;
      maxShowHeight = .6;
      maxShowWidth = .9;
      maxWidth = .8;
      showCodeAction = true;
      showLayout = "float";
      showNormalHeight = 10;
      textHlFollow = true;

      keys = {
        execAction = "o";
        quit = "q";
        quitInShow = [ "<ESC>" "q" ];
        toggleOrJump = "<cr>";
      };
    };

    # Finder disabled dut to telescope??

    hover = {
      maxHeight = .6;
      maxWidth = .8;
      openCmd = "!chomium";
      openLink = "gx";
    };

    implement = {
      enable = true;
      priority = 100;
      sign = true;
      virtualText = true;
    };

    lightbulb = {
      enable = false;
      sign = false;
      virtualText = true;
    };

    outline = {
      autoClose = true;
      autoPreview = true;
      closeAfterJump = true;
      detail = true;
      layout = "float"; # ignores the options above
      leftWidth = .3;
      maxHeight = .5;
      winPosition = "right";
      winWidth = 30;

      keys = {
        jump = "g";
        quit = "q";
        toggleOrJump = "o";
      };
    };

    rename = {
      autoSave = false;
      inSelect = true;
      projectMaxHeight = .5;
      projectMaxWidth = .5;

      keys = {
        exec = "<cr>";
        quit = "<c-e>";
        select = "x";
      };
    };

    scrollPreview = {
      scrollDown = "<c-f>";
      scrollUp = "<c-b>";
    };

    symbolInWinbar = {
      enable = true;
      colorMode = true;
      delay = 300;
      folderLevel = 1;
      hideKeyword = false;
      separator = " ›";
      showFile = true;
    };

    ui.codeAction = "󰌶";
  };
}
