{ ... }:

{
  imports = [
    ./keybindings.nix
    ./kinds.nix
    ./providers.nix
  ];

  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;

    settings = {
      appearance.nerd_font_variant = "normal";
      appearance.use_nvim_cmp_as_default = true;

      completion.documentation.auto_show = true;
      completion.documentation.auto_show_delay_ms = 1000;
      completion.list.max_items = 500;
      completion.list.selection = {
        auto_insert = false;
        preselect = true;
      };
      completion.menu.draw.treesitter = [ "lsp" ]; # what is this doing?
      # https://cmp.saghen.dev/configuration/reference.html#completion-menu-draw
      completion.menu.draw.components.kind_icon.text.__raw = ''
        function(ctx)
          -- print(vim.inspect(ctx))
          return ctx.kind_icon .. ctx.icon_gap
        end
      '';
      fuzzy.prebuilt_binaries.download = false;
      signature.enabled = false;
      snippets.preset = "luasnip";
    };
  };
}
