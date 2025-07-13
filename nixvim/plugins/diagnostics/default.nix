{ ... }:

{
  imports = [
    ./trouble.nix
    ./keymaps.nix
  ];

  diagnostic.settings = {
    virtual_text = {
      current_line = true;
    };
    virtual_lines = false;

    update_in_insert = true;
    severity_sort = true;
  };

  plugins.lsp-lines.luaConfig.post = ''
    wk.add {
      { "<leader>tD", icon = "  󰊠 " },
      { "<leader>td", icon = " 󰊠 " },
      }
  '';

  keymaps = [
    {
      key = "<leader>tD";
      action.__raw = ''
        function()
          local diag_config = vim.diagnostic.config()
          vim.diagnostic.config({
            virtual_lines = not diag_config.virtual_lines,
          })
          vim.notify(
            "Virtual Lines " .. (diag_config.virtual_lines and  "disabled" or "enabled" ),
            vim.log.levels.INFO,
            { title = "Diagnostics", render = "compact" }
          )
        end
      '';
      options.desc = "Toggle virtual diagnostic lines";
    }

    {
      key = "<leader>td";
      action.__raw = ''
        function()
          local virtual_text
          local diag_config = vim.diagnostic.config()

          if diag_config.virtual_text == true then
            virtual_text = { current_line = true }
          else 
            virtual_text = true
          end

          vim.diagnostic.config({
            virtual_text = virtual_text,
          })
          vim.notify(
            "Virtual text " .. (virtual_text == true and "enabled" or "disabled" ),
            vim.log.levels.INFO,
            { title = "Diagnostics", render = "compact" }
          )
        end
      '';
      options.desc = "Toggle virtual diagnostic text";
    }
  ];
}
