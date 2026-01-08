{ pkgs, ... }:

{
  plugins.lsp.servers.lua_ls = {
    enable = true;

    settings = {
      telemetry.enable = false;
    };

    extraOptions = {
      on_init.__raw = ''
        function(client)
          -- trade-off: just index the most important paths instead of all runtime paths to keep lsp performance acceptable
          -- also doesn't foce disabling byte-compilation for packages when inspecting source code
          local library = {
            vim.env.VIMRUNTIME,
            "${pkgs.vimPlugins.luasnip}",
            "${pkgs.vimPlugins.nvim-treesitter}",
            "${pkgs.vimPlugins.gitsigns-nvim}",
            "${pkgs.vimPlugins.copilot-lua}",
            "${pkgs.vimPlugins.telescope-nvim}",
            "${pkgs.vimPlugins.blink-cmp}",
            "${pkgs.vimPlugins.which-key-nvim}",
            "${pkgs.vimPlugins.oil-nvim}",
            "${pkgs.vimPlugins.lualine-nvim}",
            "${pkgs.vimPlugins.conform-nvim}",
            "${pkgs.vimPlugins.fidget-nvim}",
          }
          -- for i, path in ipairs(vim.api.nvim_list_runtime_paths()) do
          --   if i ~= 2 and not path:match("/after") and not path:match("treesitter%-grammar") then
          --     table.insert(library, path)
          --   end
          -- end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            workspace = {
              checkThirdParty = false,
              library = library,
            }
          })
        end
      '';
    };
  };
}
