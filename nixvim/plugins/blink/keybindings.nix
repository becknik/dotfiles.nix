{ ... }:

{
  plugins.blink-cmp.settings.keymap = {
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
    "<C-e>" = [
      "hide"
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
            cmp.show({ providers = { 'snippets' } })
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
      "fallback"
    ];
  };
}
