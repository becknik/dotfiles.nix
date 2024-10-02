{
  plugins.cmp = {
    luaConfig.pre = "local lsnip = require('luasnip')";

    settings.mapping = {
      # copy-pasta from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
      # "<tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<tab>" = ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          elseif lsnip.locally_jumpable(1) then
            lsnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" })
      '';

      # "<s-tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      "<s-tab>" = ''
        cmp.mapping(function(fallback)
          if lsnip.locally_jumpable(-1) then
            lsnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })
      '';

      # "<cr>" = "cmp.mapping.confirm({ select = true })";
      "<cr>" = ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            if lsnip.expandable() then
              lsnip.expand()
            else
              cmp.confirm { select = true }
            end
          else
            fallback()
          end
        end)
      '';
      "<s-cr>" = ''
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }
      '';


      "<c-space>" = "cmp.mapping.complete()";
      "<c-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
      "<c-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
      "<c-q>" = "cmp.mapping.abort()";

      "<c-u>" = "cmp.mapping.scroll_docs(4)";
      "<c-d>" = "cmp.mapping.scroll_docs(-4)";
    };
  };
}
