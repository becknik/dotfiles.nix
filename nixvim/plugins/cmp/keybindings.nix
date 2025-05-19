{
  plugins.cmp.luaConfig.post = ''
    local handlers = require('nvim-autopairs.completion.handlers')
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done({
        filetypes = {
          -- "*" is a alias to all filetypes
          ["*"] = {
            ["("] = {
              kind = {
                -- https://github.com/prabirshrestha/vim-lsp/blob/master/autoload/lsp/omni.vim#L6
                cmp.lsp.CompletionItemKind.Function,
                cmp.lsp.CompletionItemKind.Method,
                cmp.lsp.CompletionItemKind.Constructor,
                -- cmp.lsp.CompletionItemKind.Variable,
              },
              -- somehow, the autopair integration wouldn't work any other way...
              -- can't explain it in any other way...
              handler = function(char, item, bufnr, rules, commit_character)
                handlers["*"](char, item, bufnr, rules, commit_character)
              end,
            }
          }
        }
      })
    )
  '';

  plugins.cmp.settings.mapping = {
    "<c-space>" = "cmp.mapping.complete()";
    "<esc>" = # lua
      ''
        function(fallback)
          if cmp.visible() and require("copilot.suggestion").is_visible() then
            cmp.close()
          else
            fallback()
          end
        end
      '';

    "<cr>" = # lua
      ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
          elseif require("luasnip").expandable() then
            require("luasnip").expand()
          else
            fallback()
          end
        end, { "i", "s" })
      '';

    "<tab>" = # lua
      ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").locally_jumpable(1) then
            -- TODO
            if require'copilot.suggestion'.is_visible() then
              require'copilot.suggestion'.accept()
            else
              require("luasnip").jump(1)
            end
          else
            fallback()
          end
        end, { "i", "s" })
      '';
    "<s-tab>" = # lua
      ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").locally_jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })
      '';

    # "(" = # lua
    #   ''
    #     cmp.mapping(function(fallback)
    #       if cmp.visible() then
    #         local entry = cmp.get_selected_entry()
    #         local kind  = entry and entry:get_completion_item().kind
    #         -- https://github.com/prabirshrestha/vim-lsp/blob/master/autoload/lsp/omni.vim#L6
    #         if kind == 2 or kind == 3 or kind == 4 then
    #         cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
    #         else
    #           fallback()
    #         end
    #       else
    #         fallback()
    #       end
    #     end, { "i", "s" })
    #   '';

    "." = # lua
      ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            local kind  = entry and entry:get_completion_item().kind

            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
              commit_character = false,
            })

            vim.schedule(function()
              local action
              -- https://github.com/prabirshrestha/vim-lsp/blob/master/autoload/lsp/omni.vim#L6
              if kind == 2 or kind == 3 or kind == 4 then
                action = "<Right>."
              else
                action = "."
              end
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(action, true, false, true),
                "n",
                true
                )
            end)
          else
            fallback()
          end
        end, { "i", "s" })
      '';

    "<s-cr>" = # lua
      "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
    "<c-n>" = # lua
      "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
    "<c-p>" = # lua
      "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
    "<c-q>" = # lua
      "cmp.mapping.abort()";

    "<c-y>" = # lua
      "cmp.mapping.scroll_docs(1)";
    "<c-e>" = # lua
      "cmp.mapping.scroll_docs(-1)";
    "<c-u>" = # lua
      "cmp.mapping.scroll_docs(4)";
    "<c-d>" = # lua
      "cmp.mapping.scroll_docs(-4)";
  };
}
