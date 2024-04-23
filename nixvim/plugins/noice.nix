{ ... }:

{
  plugins.noice = {
    enable = true;

    lsp.override = {
      "vim.lsp.util.convert_input_to_markdown_lines" = true;
      "vim.lsp.util.stylize_markdown" = true;
      "cmp.entry.get_documentation" = true;
    };
    presets = {
      bottom_search = true; # use a classic bottom cmdline for search
      command_palette = true; # position the cmdline and popupmenu together
      long_message_to_split = true; # long messages will be sent to a split
      inc_rename = false; # enables an input dialog for inc-rename.nvim
      lsp_doc_border = false; # add a border to hover docs and signature help
    };

    # filter out messages on redo/ undo and yank 
    routes = let opts = { skip = true; }; in [
      {
        inherit opts;
        filter = {
          event = "msg_show";
          kind = "";
          find = "^%d+ lines? yanked$";
        };
      }
      {
        inherit opts;
        filter = {
          event = "msg_show";
          kind = "";
          find = "^%d+ %a+ lines?";
        };
      }
    ];
  };

  extraConfigLuaPost = ''require("telescope").load_extension("noice")'';
}
