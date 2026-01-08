{
  config,
  pkgs,
  withDefaultKeymapOptions,
  ...
}:

{
  imports = [
    ./file-browser.nix
    ./zoxide.nix
  ];

  plugins.telescope = {
    # https://youtu.be/u_OORAL_ SM?feature=shared&t=442
    extensions = {
      fzf-native.enable = true;
      frecency.enable = true;
      frecency.package = pkgs.vimUtils.buildVimPlugin {
        name = "telescope-frecency.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "becknik";
          repo = "telescope-frecency.nvim";
          rev = "9d8a9eed4d8bcbd0ea5616e1fbfd83e601d2f62b";
          hash = "sha256-bdz43VdgnBHOOfU3mwrkVvfqUVs94nS3DZBKQPtHfVI=";
        };
        dependencies =
          (with pkgs.vimPlugins; [
            telescope-nvim
            plenary-nvim
            nvim-web-devicons
          ])
          ++ [ config.dependencies.ripgrep.package ];
        nvimSkipModule = [
          "frecency.types"
        ];
      };
      frecency.settings = {
        db_version = "v2";
        preceding = "opened";
        hide_current_buffer = true;
        show_filter_column = false;
      };
      live-grep-args.enable = true;
      ui-select.enable = true; # replaces the vim.ui.select with telescope
      undo.enable = true;
    };
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "telescope-luasnip.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "benfowler";
        repo = "telescope-luasnip.nvim";
        rev = "07a2a2936a7557404c782dba021ac0a03165b343";
        hash = "sha256-9XsV2hPjt05q+y5FiSbKYYXnznDKYOsDwsVmfskYd3M=";
      };
    })
  ];

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>fg", icon = " " },
      { "U", icon = " 󰋚 " },
    }

    require'telescope'.load_extension'luasnip'
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "U";
      action = "Telescope frecency workspace=CWD";
      options.cmd = true;
      options.desc = "Find in Frecency";
    }
    {
      key = "<leader>fg";
      action = "Telescope live_grep_args live_grep_args theme=ivy";
      options.cmd = true;
      options.desc = "Search in live Grep (with args)";
    }
    {
      key = "<leader>u";
      action = "Telescope undo";
      options.cmd = true;
      options.desc = "Find in Undo tree";
    }
    {
      key = "<leader>fL";
      action = "Telescope luasnip";
      options.cmd = true;
      options.desc = "Find in Luasnip snippets";
    }
  ];

  autoCmd = [
    {
      event = [ "VimEnter" ];
      command = "FrecencyValidate";
    }
  ];
}
