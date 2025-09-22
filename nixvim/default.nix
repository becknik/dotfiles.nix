{ pkgs, ... }:

{
  imports = [
    ./options.nix

    ./plugins
    ./scripts
  ];

  config.globals.mapleader = " "; # "," "\"

  config = {
    clipboard.providers.wl-copy.enable = pkgs.stdenv.isLinux;

    # colorschemes.kanagawa.enable = true;
    colorschemes.rose-pine.enable = false;
    colorschemes.oxocarbon.enable = true;
    colorschemes.github-theme.enable = false;
    # https://github.com/nyoom-engineering/nyoom.nvim
    # https://github.com/mcchrish/vim-no-color-collections
    extraConfigLua = ''
      for i, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
        local group = string.format("CmpItemKind%s", kind)
        local bg = vim.api.nvim_get_hl(0, { name = group })["bg"]
        bg = bg and string.format("#%06X", bg) or "NONE"
        vim.api.nvim_set_hl(0, group, { fg = bg })
      end
    '';

    env = { };
    files = { };

    impureRtp = false; # "keep .config/nvim & .config/nvim/after in runtime path"
    # have to do this manually, maybe due to "exotic" setup using flake packages attr?
    extraConfigLuaPre = ''
      local config_dir = vim.fn.stdpath('config')
      local lua_patterns = {
        config_dir .. '/lua/?.lua',
        config_dir .. '/lua/?/init.lua',
      }
      package.path = package.path .. ';' .. table.concat(lua_patterns, ';')
      dofile(config_dir .. '/init.lua')
    '';

    withPython3 = false;
    withRuby = false;

    # experimental lua loader
    luaLoader.enable = true;
    performance = {
      byteCompileLua = {
        enable = true;
        initLua = true; # default, but comes in handy when debugging
        luaLib = true;
        plugins = false;
        nvimRuntime = false;
      };
    };

    editorconfig.enable = true;
    plugins.lz-n.enable = true;
  };
}
