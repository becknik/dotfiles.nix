{ pkgs, ... }:

{
  plugins = {
    # https://github.com/HiPhish/rainbow-delimiters.nvim
    rainbow-delimiters = {
      enable = true;
      strategy = {
        "" = "local";
      };
    };

    indent-blankline = {
      enable = true;
      package = pkgs.vimPlugins.indent-blankline-nvim.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "MomePP";
          repo = "indent-blankline.nvim";
          rev = "c3d7f63b5a625654b016c3ac2cbfb1f0ed02f028";
          sha256 = "sha256-WZP/GtR9dDtUuen3vEiS+aUUUikWOLCtBnDT9nqo9s4=";
        };

        patches = (oldAttrs.patches or [ ]) ++ [
          ./indent-blankline-error-fix.patch
        ];
      });

      luaConfig = {
        pre = ''
          local highlight = {
              "RainbowRed",
              "RainbowYellow",
              "RainbowBlue",
              "RainbowOrange",
              "RainbowGreen",
              "RainbowViolet",
              "RainbowCyan",
          }
          local hooks = require "ibl.hooks"
          -- create the highlight groups in the highlight setup hook, so they are reset
          -- every time the colorscheme changes
          hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
              vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
              vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
              vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
              vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
              vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
              vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
              vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
          end)

          vim.g.rainbow_delimiters = { highlight = highlight }
        '';
        post = ''
          hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        '';
      };

      settings.scope.highlight.__raw = "highlight";
    };
  };
}
