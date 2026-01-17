{
  pkgs,
  withDefaultKeymapOptions,
  mapToModeAbbr,
  ...
}:

{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "classy.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "becknik";
        repo = "classy.nvim";
        rev = "3b0e29198ed192c48781a56083802880c61a735d";
        hash = "sha256-49Y8p9URl2VY++TQtHJfDcbQ6arXVAaMrU3vLVkraFM=";
      };
      nvimSkipModule = [
        "classy.config"
        "classy.queries"
        "classy.utils"
        "classy"
      ];
    })
  ];

  extraConfigLua = ''
    require'classy'.setup()
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>ca";
      action = "ClassyAddClass";
      mode = mapToModeAbbr [ "normal" ];
      options.cmd = true;
      options.desc = "Classy Add Class";
    }
    {
      key = "<leader>cd";
      action = "ClassyRemoveClass";
      mode = mapToModeAbbr [ "normal" ];
      options.cmd = true;
      options.desc = "Classy Remove Class";
    }
    {
      key = "<leader>cr";
      action = "ClassyResetClass";
      mode = mapToModeAbbr [ "normal" ];
      options.cmd = true;
      options.desc = "Classy Reset Class";
    }
  ];
}
