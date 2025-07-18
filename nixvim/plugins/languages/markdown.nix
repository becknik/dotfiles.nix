{ withDefaultKeymapOptions, ... }:

{
  # https://github.com/iamcco/markdown-preview.nvim/
  # such a cool plugin
  plugins = {
    markdown-preview = {
      enable = true;
      settings = {
        auto_close = 0;
        # browser = "firefox";
        open_to_the_world = 0; # default
        combine_preview = 0; # default
        echo_preview_url = 1;
        theme = "dark"; # default
        preview_options = {
          content_editable = 1;
          hide_yaml_meta = 1; # default
        };
      };
    };

    render-markdown = {
      enable = true;
      settings = {
        completions.lsp.enabled = true;
        signs.enabled = false;
        file_types = [
          "markdown"
          "codecompanion"
        ];
      };
    };
  };

  extraConfigLua = ''
    wk.add {{ 
      "<leader>lm",
      icon = "",
      cond = function()
        return vim.bo.filetype == "markdown"
      end,
    }}'';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>lm";
      action = "MarkdownPreviewToggle";
      options.cmd = true;
      options.desc = "Toggle Markdown Preview";
    }
  ];
}
