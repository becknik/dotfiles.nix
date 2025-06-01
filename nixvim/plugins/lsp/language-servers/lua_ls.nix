{ ... }:

{
  plugins.lsp.servers.lua_ls = {
    enable = true;

    settings = {
      runtime.version = "LuaJIT";
      diagnostics.globals = [ "vim" ];
      workspace = {
        # vim.api.nvim_get_runtime_file("", true) destroys cmp completion (reloads lsp on every key press)
        library.__raw = ''vim.env.VIMRUNTIME'';
        checkThirdParty = false;
      };
      telemetry.enable = false;
    };
  };
}
