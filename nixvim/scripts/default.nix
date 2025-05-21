{ config, ... }:

{
  extraFiles = {
    diagnostic-counter-signs.source = ./diagnostic-counter-signs.lua;
  };

  extraConfigLua = ''
    vim.cmd('luafile ${config.extraFiles.diagnostic-counter-signs.source}')
  '';
}
