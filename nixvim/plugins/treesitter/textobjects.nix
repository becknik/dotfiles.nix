{ ... }:

{
  extraConfigLua = builtins.readFile ./textobjects.lua;

  # https://github.com/nvim-treesitter/nvim-treesitter-textobjects

  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "<leader>.", icon = "󰆾  ", desc = "Textobject Movement"  },
      { "<leader>,", icon = "󰆾 󰁍 ", desc = "Textobject Movement"  },
    }
  '';

  plugins.treesitter-textobjects = {
    enable = true;
    # don't find this very useful - maybe I just don't get it tho
    lspInterop.enable = false;

    swap = {
      enable = true;
      swapNext = {
        "<leader>.p" = "@parameter.inner";
        "<leader>.=" = "@assignment.outer";
        "<leader>.a" = "@attribute.outer";
        "<leader>.s" = "@statement.outer";
      };
      swapPrevious = {
        "<leader>,p" = "@parameter.inner";
        "<leader>,=" = "@assignment.outer";
        "<leader>,a" = "@attribute.outer";
        "<leader>,s" = "@statement.outer";
      };
    };

    move = {
      enable = true;
      setJumps = true;
      # pre-occupied by extension to other plugins from ./textobjects.lua:
      # ]d, ]D, ]s, ]h

      gotoNextStart = {
        "]<" = "@assignment.lhs";
        "]>" = "@assignment.rhs";
        "]=" = "@assignment.inner";
        # "]=" = "@assignment.outer";

        "]a" = "@attribute.inner";
        "]A" = "@attribute.outer";

        "]k" = "@block.inner";
        "]K" = "@block.outer";

        "](" = "@call.inner";
        "]." = "@call.outer";

        # "]c" = "@class.inner";
        "]C" = "@class.outer";

        "]c" = "@comment.inner";

        "]i" = "@conditional.inner";
        "]I" = "@conditional.outer";

        "]f" = "@function.inner";
        "]F" = "@function.outer";

        "]l" = "@loop.inner";
        "]L" = "@loop.outer";

        "]n" = "@number.inner";

        "]p" = "@parameter.inner";
        "]P" = "@parameter.outer";

        "]x" = "@regex.inner";

        "]r" = "@return.inner";
        "]R" = "@return.outer";

        "]S" = "@statement.outer";
      };
      gotoPreviousStart = {
        "[<" = "@assignment.lhs";
        "[>" = "@assignment.rhs";
        "[=" = "@assignment.inner";
        #"[=" = "@assignment.outer";

        "[a" = "@attribute.inner";
        "[A" = "@attribute.outer";

        "[k" = "@block.inner";
        "[K" = "@block.outer";

        "[(" = "@call.inner";
        "[." = "@call.outer";

        #"[c" = "@class.inner";
        "[C" = "@class.outer";

        "[c" = "@comment.inner";

        "[i" = "@conditional.inner";
        "[I" = "@conditional.outer";

        "[f" = "@function.inner";
        "[F" = "@function.outer";

        "[l" = "@loop.inner";
        "[L" = "@loop.outer";

        "[n" = "@number.inner";

        "[p" = "@parameter.inner";
        "[P" = "@parameter.outer";

        "[x" = "@regex.inner";

        "[r" = "@return.inner";
        "[R" = "@return.outer";

        "[S" = "@statement.outer";
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
        builtins.foldl' (acc: x: acc // x) { } [
          (generatePairs "=" "assignment")
          {
            "i<" = "@assignment.rhs";
            "i>" = "@assignment.lhs";
          }

          (generatePairs "a" "attribute")
          (generatePairs "k" "block")

          (generatePairs "." "call")
          (generatePairs "(" "call")

          (generatePairs "C" "class")
          (generatePairs "c" "comment")

          (generatePairs "i" "conditional")
          # {
          #   "ii" = "@conditional.inner";
          #   "aI" = "@conditional.outer";
          # }
          (generatePairs "f" "function")
          # {
          #   "if" = "@function.inner";
          #   "aF" = "@function.outer";
          # }
          (generatePairs "l" "loop")
          # {
          #   "il" = "@loop.inner";
          #   "aL" = "@loop.outer";
          # }

          {
            "n" = "@number.inner";
          }
          (generatePairs "P" "parameter")
          # {
          #   "ip" = "@parameter.inner";
          #   "aP" = "@parameter.outer";
          # }

          (generatePairs "x" "regex")

          (generatePairs "r" "return")
          # {
          #   "ir" = "@return.inner";
          #   "aR" = "@return.outer";
          # }

          (generatePairs "S" "statement")
        ];
    };
  };
}
