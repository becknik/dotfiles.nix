{ ... }:

{
  # https://nix-community.github.io/nixvim/plugins/lspsaga/index.html
  # https://nvimdev.github.io/lspsaga/
  plugins.lspsaga = {
    enable = true;

    codeAction = {
      onlyInCursor = false;
      showServerName = true;
      extendGitSigns = false; # this is noise
    };

    outline = {
      # TODO en- and disabling this changes nothing
      detail = true;
      winWidth = 50;
    };

    rename.keys.quit = "q";

    # what is this?
    symbolInWinbar.enable = false;

    ui.codeAction = "󰌶";
    lightbulb.sign = false;
    lightbulb.debounce = 200;
  };
}
