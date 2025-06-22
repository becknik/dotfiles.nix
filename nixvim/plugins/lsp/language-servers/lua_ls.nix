{ ... }:

{
  plugins.lsp.servers.lua_ls = {
    enable = true;

    settings = {
      runtime.version = "LuaJIT";
      workspace = {
        # vim.api.nvim_get_runtime_file("", true) destroys cmp completion (reloads lsp on every key press)
        library.__raw = ''vim.env.VIMRUNTIME'';
        checkThirdParty = false;
      };
      telemetry.enable = false;
    };
  };

  plugins.lazydev = {
    enable = true;
    lazyLoad.settings.ft = "lua";

    settings = {
      enabled = true;
      library = [
        {
          path = "\${3rd}/luv/library";
          words = [ "vim%.uv" ];
        }
      ];
    };
  };
}
