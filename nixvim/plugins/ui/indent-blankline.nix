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
      package = pkgs.vimPlugins.indent-blankline-nvim.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "MomePP";
          repo = "indent-blankline.nvim";
          rev = "da3c95952be0d7082d4212b40bfc00890c9282fa";
          sha256 = "sha256-drSw6AYC6+X89F9SNOU1v3PePgiJEaSYRPmSv2QwZU8=";
        };
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
