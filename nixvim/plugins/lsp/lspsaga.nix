{ ... }:

{
  # TODO sort out the default values

  # https://nix-community.github.io/nixvim/plugins/lspsaga/index.html
  # https://nvimdev.github.io/lspsaga/
  plugins.lspsaga = {
    enable = true;

    beacon.enable = true;
    beacon.frequency = 7;

    callhierarchy = {
      layout = "float";

      keys = {
        close = "<C-c>k";
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
      extendGitSigns = false;
      numShortcut = true;
      onlyInCursor = true;

      keys = {
        exec = "<CR>";
        quit = [ "<ESC>" "q" ];
      };
    };

    # :Lspsaga peek_definition; :Lspsaga peek_type_definition;
    # :Lspsaga goto_definition; :Lspsaga goto_type_definition
    definition = {
      height = .5;
      width = .6;

      keys = {
        close = "<C-c>k";
        edit = "<C-c>o";
        quit = "q";
        split = "<C-c>i";
        tabe = "<C-c>t";
        vsplit = "<C-c>v";
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
        toggleOrJump = "<CR>";
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
        exec = "<CR>";
        quit = "<C-e>";
        select = "x";
      };
    };

    scrollPreview = {
      scrollDown = "<C-f>";
      scrollUp = "<C-b>";
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
