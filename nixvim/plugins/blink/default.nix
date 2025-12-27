{ pkgs, ... }:

{
  imports = [
    ./keybindings.nix
    ./kinds.nix
    ./providers.nix
  ];

  plugins.blink-cmp =
    let
      blink-cmp = pkgs.vimPlugins.blink-cmp;

      blink-cmp-fuzzy-lib-native = blink-cmp.passthru.blink-fuzzy-lib.overrideAttrs (prev: {
        patches = [
          ./blink-fuzzy-optimization.patch
        ];

        env = (prev.env or { }) // {
          RUSTFLAGS = pkgs.lib.concatStringsSep " " [
            "-C"
            "target-cpu=native"
          ];
        };
      });
      blink-cmp-native = blink-cmp.overrideAttrs (old: {
        preInstall =
          let
            ext = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
          in
          ''
            mkdir -p target/release
            ln -s ${blink-cmp-fuzzy-lib-native}/lib/libblink_cmp_fuzzy${ext} target/release/libblink_cmp_fuzzy${ext}
          '';
        passthru = old.passthru // {
          blink-fuzzy-lib = blink-cmp-fuzzy-lib-native;
        };
      });

    in
    {
      enable = true;
      setupLspCapabilities = true;
      package = blink-cmp-native;

      settings = {
        enabled.__raw = ''
          function()
            return not vim.tbl_contains({ 'sagarename' }, vim.bo.filetype)
              and vim.b.completion ~= false
          end'';

        appearance.nerd_font_variant = "normal";
        appearance.use_nvim_cmp_as_default = true;

        completion.documentation.auto_show = false;
        completion.list.max_items = 250;
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
        completion.menu.draw.__raw = ''
          {
            columns = {
              { "item_idx" },
              { "kind_icon" },
              -- :lua print(vim.inspect(vim.lsp.get_active_clients()[1].capabilities.textDocument.completion))
              { "label", "label_description", gap = 1 },
            },
            components = {
              item_idx = {
                text = function(ctx)
                  return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx)
                end,
                highlight = 'BlinkCmpItemIdx' -- optional, only if you want to change its color
              }
            }
          }
        '';

        fuzzy.prebuilt_binaries.download = false;
        fuzzy.implementation = "rust";
        fuzzy.sorts.__raw = ''
          {
            "exact",
            "score",
            "sort_text",
          }
        '';

        signature.enabled = true;
        signature.trigger.show_on_insert = true;
        signature.window.show_documentation = true;
        snippets.preset = "luasnip";

        completion.menu.border = "single";
        completion.documentation.window.border = "single";
        signature.window.border = "single";
      };
    };
}
