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
                "markdown", "gitcommit"
              }, vim.bo.filetype)
              if shoulntdBeIncluded then
                return true
              end

              cmp.show { providers = { 'snippets' } }
              return true
            end
          '';
        }
        "fallback"
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
              if not cmp.is_visible() then
                cmp.show {
                  providers = { 'snippets' },
                  completion = { documentation = { auto_show = true } }
                }
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
      "<C-k>" = [
        "show_signature"
        "hide_signature"
      ];

      # FIXME: doesn't work any more - since v.1.4.1 update?
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
}
