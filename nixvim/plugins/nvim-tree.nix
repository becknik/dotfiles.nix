{ helpers, withDefaultKeymapOptions, ... }:

{
  # disable netrw
  globals.loaded_netrw = 1;
  globals.loaded_netrwPluin = 1;

  # TODO try out https://github.com/ms-jpq/chadtree
  plugins.nvim-tree = {
    enable = true;

    autoClose = true;
    hijackCursor = true;

    actions = {
      expandAll.exclude = [ ".git" "target" "build" "result" ];
      openFile.quitOnOpen = true;
    };
    git.showOnOpenDirs = false;
    renderer = {
      groupEmpty = true;
      highlightGit = true;
      highlightOpenedFiles = "icon";
      icons.show.modified = false;
    };
    #trash.cmd

    view = {
      cursorline = true;
      number = true;
      relativenumber = true;
      side = "right";
      float.enable = false;
    };

    onAttach = helpers.mkRaw (builtins.readFile ./nvim-tree.lua);
  };

  keymaps = withDefaultKeymapOptions [
    { key = "<c-h>"; action = "<cmd>NvimTreeToggle<cr>"; }
  ];
}
