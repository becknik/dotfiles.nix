{ ... }:

{
  plugins.blink-cmp = {
    luaConfig.pre = ''
      local cmp_kinds = require'blink.cmp.types'.CompletionItemKind
    '';

    settings.keymap = {
      preset = "none";
      "<C-space>" = [
        "show"
        "show_documentation"
        "hide_documentation"
      ];
      "<CR>" = [
        "accept"
        "fallback"
      ];
      "<esc>" = [
        "hide"
        {
          __raw = ''
            function(cmp)
              if require'copilot.suggestion'.is_visible() then
                require'copilot.suggestion'.dismiss()
                return true
              end
              return false
            end
          '';
        }
        "fallback"
      ];
      "." = [
        {
          __raw = ''
            function(cmp)
              local entry = cmp.get_selected_item()
              if not entry then
                return false
              end

              local kind = entry.kind
              local is_function_like = kind == cmp_kinds.Function or
              kind == cmp_kinds.Method or
              kind == cmp_kinds.StaticMethod or
              kind == cmp_kinds.Constructor
              local is_variable_like = kind == cmp_kinds.Variable or
              kind == cmp_kinds.Constant or
              kind == cmp_kinds.Field or
              kind == cmp_kinds.Property or
              kind == cmp_kinds.Struct or
              kind == cmp_kinds.Object or
              kind == cmp_kinds.Reference or
              kind == cmp_kinds.Module or
              kind == cmp_kinds.Enum

              if not is_function_like and not is_variable_like then
                return false
              end

              cmp.accept()
              vim.schedule(function()
                local action = is_function_like and "<Right>." or "."
                vim.api.nvim_feedkeys(
                  vim.api.nvim_replace_termcodes(action, true, false, true),
                  "n",
                  true
                )
              end)
              return true
            end
          '';
        }
        "fallback"
      ];

      "<C-e>" = [
        "hide"
        "fallback"
      ];
      "<C-x>" = [
        {
          __raw = ''
            function(cmp)
              print("Selected entry:", vim.inspect(entry))
              if cmp.is_active() then
                cmp.hide()
              end
              if require'copilot.suggestion'.is_visible() then
                require'copilot.suggestion'.dismiss()
              end
              -- switch to normal mode
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
              return true
            end
          '';
        }
      ];
      "<C-n>" = [
        "select_next"
        {
          __raw = ''
            function(cmp)
              if require'luasnip'.locally_jumpable(1) then
                cmp.snippet_forward()
                return true
              end
              return false
            end
          '';
        }
        {
          __raw = ''
            function(cmp)
              if not cmp.is_active() then
                cmp.show({ providers = { 'snippets' } })
                return true
              end
              return false
            end
          '';
        }
      ];
      "<C-p>" = [
        "select_prev"
        {
          __raw = ''
            function(cmp)
              if require'luasnip'.locally_jumpable(-1) then
                cmp.snippet_backward()
                return true
              end
              return false
            end
          '';
        }
      ];

      "<Tab>" = [
        "select_next"
        {
          __raw = ''
            function(cmp)
              if require'copilot.suggestion'.is_visible() then
                require'copilot.suggestion'.accept()
                return true
              end
              return false
            end
          '';
        }
        "fallback"
      ];
      "<S-Tab>" = [
        "select_prev"
        "fallback"
      ];

      "<C-d>" = [
        "scroll_documentation_up"
        "fallback"
      ];
      "<C-u>" = [
        "scroll_documentation_down"
        "fallback"
      ];
    };
  };
}
