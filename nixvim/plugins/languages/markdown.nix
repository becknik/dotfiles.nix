{ pkgs, withDefaultKeymapOptions, ... }:

{
  plugins.markdown-preview = {
    enable = true;
    settings = {
      auto_close = false;
      # browser = "firefox";
      open_to_the_world = false; # default
      combine_preview = false; # default
      theme = "dark";
      preview_options = {
        content_editable = true;
        hide_yaml_meta = true; # default
      };
    };
  };

  # TODO not loaded into neovim
  extraPackages = with pkgs.vimPlugins; [ vim-markdown-toc ];

  keymaps = withDefaultKeymapOptions [
    { key = "<leader>mdps"; action = "<cmd>MarkdownPreview<cr>"; }
    { key = "<leader>mdpp"; action = "<cmd>MarkdownPreviewStop<cr>"; }
    { key = "<leader>mdpt"; action = "<cmd>MarkdownPreviewToggle<cr>"; }
    { key = "<leader>mdg"; action = "<cmd>GenTocGFM<cr>"; }
    # : :GenTocRedcarpet :GenTocGitLab :GenTocMarked
  ];
}
