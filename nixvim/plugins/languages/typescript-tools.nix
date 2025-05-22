{ ... }:

{
  plugins.typescript-tools = {
    enable = true;

    settings = {
      capabilities.__raw = "vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())";

      on_attach.__raw = ''
        function(client, bufnr)
          vim.keymap.set(
            "n",
            "<leader>ci",
            function()
              vim.api.nvim_command("TSToolsOrganizeImports")
            end,
            { buffer = bufnr, desc = "organize Imports" }
          )
          vim.keymap.set(
            "n",
            "<leader>cm",
            function()
              vim.api.nvim_command("TSToolsAddMissingImports")
            end,
            { buffer = bufnr, desc = "add Missing Imports" }
          )

          vim.keymap.set(
            "n",
            "<leader>cu",
            function()
              vim.api.nvim_command("TSToolsRemoveUnused")
            end,
            { buffer = bufnr, desc = "remove Unused" }
          )
          vim.keymap.set(
            "n",
            "<leader>cf",
            function()
              vim.api.nvim_command("TSToolsFixAll")
            end,
            { buffer = bufnr, desc = "Fix all" }
          )
          wk.add({ { "<leader>ci", icon = "󰛦 " }, }, { buffer = bufnr, })

          wk.add({
            { "<leader>ci", icon = "󰛦 " },
            { "<leader>cm", icon = "󰛦 " },
            { "<leader>cu", icon = "󰛦 " },
            { "<leader>cf", icon = "󰛦 " },
          }, { buffer = bufnr, })
        end
      '';

      root_dir.__raw = "require('lspconfig.util').root_pattern('tsconfig.json')";
      settings.tsserver.format.enable = false;
    };
  };
}
