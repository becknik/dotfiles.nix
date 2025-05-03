{ ... }:

{
  extraConfigLua = builtins.readFile ./textobjects.lua;

  # https://github.com/nvim-treesitter/nvim-treesitter-textobjects

  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "<leader>n", icon = "󰆾 ", desc = "Textobject Movement"  },
    }
  '';

  plugins.treesitter-textobjects = {
    enable = true;
    lspInterop = {
      enable = true;
      border = "double"; # “none”, “single”, “double”, “rounded”, “solid”, “shadow”
      # TODO this isn't working properly:
      #  shows error message with no parameters; with parameters the popup is empty ...
      floatingPreviewOpts = {
        height = 16;
        width = 16;
      };
      peekDefinitionCode = {
        # conflicting with diagnostics for line and cursor
        # "<leader>dl" = "@loop.outer";
        # "<leader>dc" = "@conditional.outer";

        "<leader>df" = "@function.outer";
        "<leader>dC" = "@class.outer";
      };
    };

    move = {
      enable = true;
      setJumps = true; # default
      # using `%` to get moving to gotoPreviousStart and gotoNextEnd
      # or use `,` and `<opposite bracket><same mnemonic>`
      gotoNextStart = {
        "]/" = "@comment.inner";
        "]n" = "@number.inner";
        "]R" = "@regex.inner";

        "]=" = "@assignment.outer";
        "]." = "@call.*";
        "](" = "@call.inner";

        "]r" = "@return.inner";

        "]P" = "@parameter.inner";
        "]a" = "@attribute.*";

        # "[sc" = "@scopename.outer";
        "]c" = "@conditional.inner";
        "]l" = "@loop.inner";

        "]f" = "@function.outer";
        "]C" = "@class.outer";
        "]B" = "@block.outer";
        "]F" = "@frame.outer";
      };
      gotoPreviousStart = {
        "[/" = "@comment.inner";
        "[n" = "@number.inner";
        "[R" = "@regex.inner";

        "[=" = "@assignment.outer";
        "[." = "@call.*";
        "[(" = "@call.inner";

        "[r" = "@return.inner";

        "[P" = "@parameter.inner";
        "[a" = "@attribute.*";

        # "[sc" = "@scopename.outer";
        "[c" = "@conditional.inner";
        "[l" = "@loop.inner";

        "[f" = "@function.outer";
        "[C" = "@class.outer";
        "[B" = "@block.outer";
        "[F" = "@frame.outer";
      };
    };

    select = {
      enable = true;
      lookahead = true;
      selectionModes = {
        "@parameter.outer" = "v";
        "@function.outer" = "V";
        "@class.outer" = "<c-v>";
      };
      keymaps =
        let
          generatePairs = suffix: textObjName: {
            "a${suffix}" = "@${textObjName}.outer";
            "i${suffix}" = "@${textObjName}.inner";
          };
        in
        builtins.foldl' (acc: x: acc // x) { }
          [
            (generatePairs "/" "comment")
            {
              "in" = "@number.inner";
              "n" = "@number.inner";
            }
            (generatePairs "R" "regex")

            (generatePairs "=" "assignment")
            {
              "l=" = "@assignment.lhs";
              "r=" = "@assignment.rhs";
            }
            (generatePairs "." "call")
            { "i(" = "@call.inner"; } # consistency: using this for movement

            (generatePairs "r" "return")
            { "ist" = "@statement.outer"; }

            (generatePairs "P" "parameter")
            (generatePairs "a" "attribute") # html/jsx attributes?

            { "isc" = "@scopename.inner"; } # TODO what is this?
            (generatePairs "c" "conditional")
            (generatePairs "l" "loop")

            (generatePairs "f" "function")
            (generatePairs "C" "class")

            (generatePairs "B" "block")
            (generatePairs "F" "frame")
          ];
    };

    swap = {
      enable = true;
      swapNext = {
        "<leader>n=" = "@assignment.outer";
        "<leader>n(" = "@call.inner"; # can't think of an use case, but making it available for consistency reasons
        "<leader>n." = "@call.outer";
        "<leader>np" = "@parameter.inner";
        "<leader>na" = "@attribute.inner";
        "<leader>nA" = "@attribute.outer";
        "<leader>nc" = "@conditional.inner";
        "<leader>nf" = "@function.outer";
        "<leader>nC" = "@class.outer";
      };
      swapPrevious = {
        "<leader>p=" = "@assignment.outer";
        "<leader>p(" = "@call.inner";
        "<leader>p." = "@call.outer";
        "<leader>pp" = "@parameter.inner";
        "<leader>pa" = "@attribute.inner";
        "<leader>pA" = "@attribute.outer";
        "<leader>pc" = "@conditional.inner";
        "<leader>pf" = "@function.outer";
        "<leader>pC" = "@class.outer";
      };
    };
  };
}
