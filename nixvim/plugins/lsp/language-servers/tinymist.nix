{ withDefaultKeymapOptions, ... }:

{
  lsp.servers.tinymist = {
    enable = true;
    config.on_init.__raw = ''
      function(client)
        local project_root = client.root_dir

        -- load the pinned file for this project from state
        local STORE_PATH = vim.fn.stdpath("state") .. "/tinymist_pinned.json"
        if vim.fn.filereadable(STORE_PATH) == 0 then
          return nil
        end

        local lines = vim.fn.readfile(STORE_PATH)
        local root_main_file_dict = vim.json.decode(table.concat(lines, "\n"))

        ---@diagnostic disable-next-line: param-type-mismatch
        client.request("workspace/executeCommand", {
          command = "tinymist.pinMain",
          arguments = { root_main_file_dict[project_root] },
        })
      end
    '';
  };

  userCommands = {
    "TypstPin" = {
      command.__raw = ''
        function()
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

          local current_file = vim.api.nvim_buf_get_name(0)

          ---@diagnostic disable-next-line: param-type-mismatch
          client.request("workspace/executeCommand", {
            command = "tinymist.pinMain",
            arguments = { current_file },
            ---@diagnostic disable-next-line: param-type-mismatch
          }, function(err)
            if err then
              vim.notify("Error pinning: " .. err, vim.log.levels.ERROR)
            else
              vim.notify("Successfully pinned", vim.log.levels.INFO)
              local project_root = client.root_dir

              local STORE_PATH = vim.fn.stdpath("state") .. "/tinymist_pinned.json"
              if vim.fn.filereadable(STORE_PATH) == 0 then
                vim.fn.writefile({ vim.json.encode({}) }, STORE_PATH)
              end

              local lines = vim.fn.readfile(STORE_PATH)
              local data = vim.json.decode(table.concat(lines, "\n"))
              data[project_root] = current_file

              local encoded = vim.json.encode(data)
              vim.fn.writefile({ encoded }, STORE_PATH)

              vim.notify("Successfully updated pinned files", vim.log.levels.INFO)
            end
          end, 0)
        end
      '';
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>ltp";
      action = "TypstPin";
      options.cmd = true;
      options.desc = "typst Pin Main File";
    }
  ];
}
