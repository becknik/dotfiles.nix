{
  withDefaultKeymapOptions,
  ...
}:

{
  # extraConfigLua = builtins.readFile ./textobjects.lua;

  # https://github.com/nvim-treesitter/nvim-treesitter-textobjects

  plugins.lsp.luaConfig.post = ''
    wk.add {
      { "<leader>.", icon = "󰆾  ", desc = "Textobject Movement"  },
      { "<leader>,", icon = "󰆾 󰁍 ", desc = "Textobject Movement"  },
    }
  '';

  extraConfigLua = builtins.readFile ./textobjects.lua;

  plugins.treesitter-textobjects = {
    enable = true;
    settings = {
      move.set_jumps = false;

      select = {
        enable = true;
        lookahead = true;
        # selection_modes = {
        #   "@parameter.outer" = "v";
        #   "@function.outer" = "V";
        #   "@class.outer" = "<c-v>";
        # };
        include_surrounding_whitespace = false;
      };
    };
  };

  keymaps =
    let
      binding = key: actionLua: desc: mode: {
        key = key;
        action.__raw = ''
          function()
            ${actionLua}
          end
        '';
        mode = mode;
        options.desc = desc;
      };

      swapBinding =
        key: action: target:
        (binding key (
          "require 'nvim-treesitter-textobjects.swap'." + action + "'" + target + "'"
        ) target "n");
      selectBinding =
        key: action:
        (binding key
          ("require 'nvim-treesitter-textobjects.select'.select_textobject('" + action + "', 'textobjects')")
          action
          [
            "o"
            "x"
          ]
        );
      moveBinding =
        key: action: target:
        (binding key
          ("require 'nvim-treesitter-textobjects.move'." + action + "('" + target + "', 'textobjects')")
          target
          [
            "n"
            "o"
            "x"
          ]
        );
    in
    withDefaultKeymapOptions [
      # swaps

      (swapBinding "<leader>.p" "swap_next" "@parameter.inner")
      (swapBinding "<leader>,p" "swap_previous" "@parameter.inner")

      (swapBinding "<leader>.a" "swap_next" "@attribute.outer")
      (swapBinding "<leader>,a" "swap_previous" "@attribute.outer")

      (swapBinding "<leader>.s" "swap_next" "@statement.outer")
      (swapBinding "<leader>,s" "swap_previous" "@statement.outer")

      # TODO: make one for boolean conditionals

      # selects

      (selectBinding "af" "@function.outer")
      (selectBinding "if" "@function.inner")

      (selectBinding "aS" "@statement.outer")
      (selectBinding "iS" "@statement.inner")

      (selectBinding "a=" "@assignment.outer")
      (selectBinding "i=" "@assignment.inner")
      (selectBinding "i<" "@assignment.lhs")
      (selectBinding "i>" "@assignment.rhs")

      (selectBinding "i." "@call.inner")
      (selectBinding "a." "@call.outer")

      (selectBinding "iP" "@parameter.inner")
      (selectBinding "aP" "@parameter.outer")

      (selectBinding "ix" "@regex.inner")
      (selectBinding "ax" "@regex.outer")

      (selectBinding "in" "@number.inner")
      (selectBinding "an" "@number.inner")

      (selectBinding "ir" "@return.inner")
      (selectBinding "ar" "@return.outer")

      (selectBinding "ia" "@attribute.inner")
      (selectBinding "aa" "@attribute.outer")

      (selectBinding "ic" "@comment.inner")
      (selectBinding "ac" "@comment.outer")

      (selectBinding "il" "@loop.inner")
      (selectBinding "al" "@loop.outer")

      (selectBinding "ii" "@conditional.inner")
      (selectBinding "ai" "@conditional.outer")

      (selectBinding "iC" "@class.inner")
      (selectBinding "aC" "@class.outer")

      # moves

      (moveBinding "]f" "goto_next_start" "@function.outer")
      (moveBinding "[f" "goto_previous_start" "@function.outer")

      (moveBinding "]=" "goto_next_start" "@assignment.outer")
      (moveBinding "[=" "goto_previous_start" "@assignment.outer")
      (moveBinding "]<" "goto_next_start" "@assignment.lhs")
      (moveBinding "[<" "goto_previous_start" "@assignment.lhs")
      (moveBinding "]>" "goto_next_start" "@assignment.rhs")
      (moveBinding "[>" "goto_previous_start" "@assignment.rhs")

      (moveBinding "]." "goto_next_start" "@call.outer")
      (moveBinding "[." "goto_previous_start" "@call.outer")
      (moveBinding "](" "goto_next_start" "@call.inner")
      (moveBinding "[(" "goto_previous_start" "@call.inner")
      (moveBinding "])" "goto_next_start" "@call.inner")
      (moveBinding "[)" "goto_previous_start" "@call.inner")

      (moveBinding "]P" "goto_next_start" "@parameter.inner")
      (moveBinding "[P" "goto_previous_start" "@parameter.inner")
      (moveBinding "]p" "goto_next_start" "@parameter.inner")
      (moveBinding "[p" "goto_previous_start" "@parameter.inner")

      (moveBinding "]x" "goto_next_start" "@regex.inner")
      (moveBinding "[x" "goto_previous_start" "@regex.inner")

      (moveBinding "]n" "goto_next_end" "@number.inner")
      (moveBinding "[n" "goto_previous_end" "@number.inner")

      (moveBinding "]r" "goto_next_start" "@return.inner")
      (moveBinding "[r" "goto_previous_start" "@return.inner")

      (moveBinding "]a" "goto_next_end" "@attribute.inner")
      (moveBinding "[a" "goto_previous_end" "@attribute.inner")
      (moveBinding "]A" "goto_next_start" "@attribute.outer")
      (moveBinding "[A" "goto_previous_start" "@attribute.outer")

      (moveBinding "]c" "goto_next_start" "@comment.outer")
      (moveBinding "[c" "goto_previous_start" "@comment.outer")

      (moveBinding "]l" "goto_next_start" "@loop.inner")
      (moveBinding "[l" "goto_previous_start" "@loop.inner")

      (moveBinding "]i" "goto_next_start" "@conditional.inner")
      (moveBinding "[i" "goto_previous_start" "@conditional.inner")

      (moveBinding "]C" "goto_next_start" "@class.inner")
      (moveBinding "[C" "goto_previous_start" "@class.inner")
    ];
}
