{ ... }:

{
  imports = [
    ./trouble.nix
    ./keymaps.nix
  ];

  diagnostic.settings = {
    virtual_text = true;
  };
  extraConfigLuaPre = "local diag_virtual_text_enabled = true";

  plugins.lsp-lines.enable = true;

  plugins.lsp-lines.luaConfig.post = ''
    wk.add {
      { "<leader>tD", icon = "  󰊠 " },
      { "<leader>td", icon = " 󰊠 " },
      }
  '';

  keymaps = [
    {
      key = "<leader>tD";
      action.__raw = "function() require('lsp_lines').toggle() end";
      options.desc = "Toggle lsp_lines";
    }
    {
      key = "<leader>td";
      action.__raw = "function()
        diag_virtual_text_enabled = not diag_virtual_text_enabled
        vim.diagnostic.config({ virtual_text = diag_virtual_text_enabled })
        vim.notify((diag_virtual_text_enabled and 'Enabled' or 'Disabled') .. 'Diagnostic Virtual Text' , vim.log.levels.INFO, { render = 'compact' })
      end";
      options.desc = "Toggle Diagnostic Virtual Text";
    }
  ];
}
