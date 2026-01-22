{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.blink-cmp = {
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
        {
          __raw = ''
            function(cmp)
              if cmp.is_visible() then
                cmp.hide()
              end
              if require'copilot.suggestion'.is_visible() then
                require'copilot.suggestion'.dismiss()
              end
              return false
            end
          '';
        }
        "fallback"
      ];

      "<C-x>" = [
        {
          __raw = ''
            function(cmp)
              if cmp.is_visible() then
                cmp.hide()
                return true
              end
              if require'copilot.suggestion'.is_visible() then
                require'copilot.suggestion'.dismiss()
                return true
              end
              -- switch to normal mode
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
              return true
            end
          '';
        }
      ];

      "<C-s>" = [
        {
          __raw = ''
            function(cmp)
              local shoulntdBeIncluded = vim.tbl_contains({
                "markdown", "gitcommit",
              }, vim.bo.filetype)
              if shoulntdBeIncluded then
                return false
              end

              cmp.show {
                providers = { 'snippets' },
                callback = function()
                  vim.schedule(function()
                    cmp.show_documentation()
                  end)
                end
              }
              return true
            end
          '';
        }
        "fallback"
      ];

      "<C-n>" = [
        { __raw = "function(cmp) cmp.select_next({ auto_insert = false }) end"; }
        "fallback_to_mappings"
      ];
      "<C-p>" = [
        { __raw = "function(cmp) cmp.select_prev({ auto_insert = false }) end"; }
        "fallback_to_mappings"
      ];

      "<Tab>" = [
        {
          __raw = ''
            function(cmp)
              -- not sure about this whole thing...
              if require'luasnip'.locally_jumpable(1) then
                cmp.snippet_forward()
                return true
              end

              local current_item = cmp.get_selected_item()
              if current_item and current_item.kind == vim.lsp.protocol.CompletionItemKind.Snippet then
                cmp.accept()
                return true
              end

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
      "<C-k>" = [
        "show_signature"
        "hide_signature"
      ];

      "<C-1>".__raw = "{ function(cmp) cmp.accept({ index = 1 }) end }";
      "<C-2>".__raw = "{ function(cmp) cmp.accept({ index = 2 }) end }";
      "<C-3>".__raw = "{ function(cmp) cmp.accept({ index = 3 }) end }";
      "<C-4>".__raw = "{ function(cmp) cmp.accept({ index = 4 }) end }";
      "<C-5>".__raw = "{ function(cmp) cmp.accept({ index = 5 }) end }";
      "<C-6>".__raw = "{ function(cmp) cmp.accept({ index = 6 }) end }";
      "<C-7>".__raw = "{ function(cmp) cmp.accept({ index = 7 }) end }";
      "<C-8>".__raw = "{ function(cmp) cmp.accept({ index = 8 }) end }";
      "<C-9>".__raw = "{ function(cmp) cmp.accept({ index = 9 }) end }";
      "<C-0>".__raw = "{ function(cmp) cmp.accept({ index = 10 }) end }";
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<C-n>";
      action.__raw = ''
        function()
          if require'luasnip'.choice_active() then
            require'luasnip'.change_choice(1)
          end
        end
      '';
      mode = mapToModeAbbr [
        "normal"
        "insert"
        "select"
      ];
      options.desc = "LuaSnip Next Choice";
    }
    {
      key = "<C-p>";
      action.__raw = ''
        function()
          if require'luasnip'.choice_active() then
            require'luasnip'.change_choice(-1)
          end
        end
      '';
      mode = mapToModeAbbr [
        "normal"
        "insert"
        "select"
      ];
      options.desc = "LuaSnip Prev Choice";
    }
  ];
}
