{
  lib,
  config,
  withDefaultKeymapOptions,
  ...
}:

{
  plugins.typst-preview = {
    enable = true;

    settings.dependencies_bin = {
      tinymist = "${lib.getExe config.dependencies.tinymist.package}";
      websocat = "${lib.getExe config.dependencies.websocat.package}";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>ltr";
      action = "TypstPreviewUpdate";
      options.cmd = true;
      options.desc = "typst Preview Refresh";
    }
    {
      key = "<leader>ltt";
      action = "TypstPreview";
      options.cmd = true;
      options.desc = "typst Preview Toggle";
    }
    {
      key = "<leader>lT";
      action = "TypstPreviewFollowCursor";
      options.cmd = true;
      options.desc = "typst Preview Follow Cursor";
    }
  ];
}
