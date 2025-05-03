{ withDefaultKeymapOptions, ... }:

{
  plugins.telescope.extensions.zoxide = {
    enable = true;
    settings = {

      # integration with file-browser extension
      # https://github.com/jvgrootveld/telescope-zoxide?tab=readme-ov-file#open-selection-in-telescope-file-browser
      mappings = {
        "<C-b>" = {
          action = {
            __raw = ''
              function(selection)
                file_browser.file_browser({ cwd = selection.path })
              end
            '';
          };
          keepinsert = true;
        };
      };
      prompt_title = "Zoxide Folder List";
    };

  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>fz";
      action = "Telescope zoxide list";
      options.cmd = true;
      options.desc = "Find in Zoxide list ";
    }
  ];
}
