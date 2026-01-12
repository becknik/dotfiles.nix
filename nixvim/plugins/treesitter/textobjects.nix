{ ... }:

{
  # extraConfigLua = builtins.readFile ./textobjects.lua;

  # https://github.com/nvim-treesitter/nvim-treesitter-textobjects

  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "<leader>.", icon = "󰆾  ", desc = "Textobject Movement"  },
      { "<leader>,", icon = "󰆾 󰁍 ", desc = "Textobject Movement"  },
    }

    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- Make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  '';

  plugins.treesitter-textobjects = {
    enable = true;
    settings = {
      # don't find this very useful - maybe I just don't get it tho
      lsp_interop.enable = false;

      swap = {
        enable = true;
        swap_next = {
          "<leader>.p" = "@parameter.inner";
          "<leader>.=" = "@assignment.outer";
          "<leader>.a" = "@attribute.outer";
          "<leader>.s" = "@statement.outer";
        };
        swap_previous = {
          "<leader>,p" = "@parameter.inner";
          "<leader>,=" = "@assignment.outer";
          "<leader>,a" = "@attribute.outer";
          "<leader>,s" = "@statement.outer";
        };
      };

      move = {
        enable = true;
        set_jumps = true;
        # pre-occupied by extension to other plugins from ./textobjects.lua:
        # ]d, ]D, ]s, ]h

        goto_next_start = {
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
        goto_previous_start = {
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
        selection_modes = {
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
  };
}
