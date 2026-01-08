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
        owner = "jcha0713";
        repo = "classy.nvim";
        rev = "f6bd04918699fefd22272b11ca80f5be55a51ab5";
        hash = "sha256-Vrcsg676cBY/fnDOuN6ScRQ13eG5MyNQ9fn1wT/ABVA=";
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
