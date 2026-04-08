{
  lib,
  config,
  withDefaultKeymapOptions,
  ...
}:

{
  plugins.typst-preview = {
    enable = true;

    settings = {
      dependencies_bin = {
        tinymist = "${lib.getExe config.dependencies.tinymist.package}";
        websocat = "${lib.getExe config.dependencies.websocat.package}";
      };
      get_main_file.__raw = ''
        function()
          -- figure out lsp root dir for this buffer
          local tinymist_id = nil
          for _, client in pairs(vim.lsp.get_clients({
              bufnr = 0,
              name = "tinymist",
            })) do
            tinymist_id = client.id
            break
          end

          if not tinymist_id then
            vim.notify("tinymist not running!", vim.log.levels.ERROR)
            return
          end

          local client = vim.lsp.get_client_by_id(tinymist_id)
          if not client then
            vim.notify("Couldn't find tinymist_id" .. tinymist_id, vim.log.levels.ERROR)
            return
          end
          local project_root = client.root_dir

          -- load the pinned file for this project from state
          local STORE_PATH = vim.fn.stdpath("state") .. "/tinymist_pinned.json"
          if vim.fn.filereadable(STORE_PATH) == 0 then
            return nil
          end

          local lines = vim.fn.readfile(STORE_PATH)
          local root_main_file_dict = vim.json.decode(table.concat(lines, "\n"))

          return root_main_file_dict[project_root]
        end
      '';
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
