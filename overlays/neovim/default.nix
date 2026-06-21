# Patches and overrides for neovim plugins.
#
# This overlay is applied to the nixpkgs instance nixvim is built against
# (i.e. `pkgs-unstable`), so the patched packages land in `vimPlugins`
# and are picked up by nixvim's `package = ...` options that reference
# `pkgs.vimPlugins.<name>` (without an inline `overrideAttrs`).
#
# `vimPlugins` is a `lib.makeExtensible` set, so we use `.extend` instead of
# `//`. This makes our overrides participate in the `vimPlugins` fixpoint, so
# other plugins that declare `dependencies = [ self.blink-cmp ]` (e.g.
# `blink-emoji-nvim`, `blink-nerdfont-nvim` in nixpkgs' overrides.nix) resolve
# `self.blink-cmp` to our patched derivation. Without this, those plugins keep
# referencing the stock `blink-cmp`, which leads to two conflicting `blink-cmp`
# derivations ending up in nixvim's `combinePlugins` plugin pack.
final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    self: super: {
      otter-nvim = super.otter-nvim.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          ./otter-filetype-alias-for-styled-components.patch
        ];
      });

      telescope-nvim = super.telescope-nvim.overrideAttrs (_oldAttrs: {
        patches = [ ./telescope-fname.patch ];
      });

      lspsaga-nvim = super.lspsaga-nvim.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          ./lspsaga-line-diagnostics-fix.patch
        ];
      });

      indent-blankline-nvim = super.indent-blankline-nvim.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "MomePP";
          repo = "indent-blankline.nvim";
          rev = "c3d7f63b5a625654b016c3ac2cbfb1f0ed02f028";
          sha256 = "sha256-WZP/GtR9dDtUuen3vEiS+aUUUikWOLCtBnDT9nqo9s4=";
        };

        patches = (oldAttrs.patches or [ ]) ++ [
          ./indent-blankline-error-fix.patch
        ];
      });

      # blink-cmp with a natively built (CPU-targeted) fuzzy library plus
      # a patch that makes dot-repeat skip non-insert modes (needed for
      # snippet select mode). See nixvim/plugins/blink/default.nix.
      #
      # `super.blink-cmp` is the stock derivation; `self.blink-cmp` (referenced
      # by other plugins via `dependencies = [ self.blink-cmp ]`) resolves to
      # this patched version thanks to the `.extend` fixpoint.
      blink-cmp =
        let
          blink-cmp = super.blink-cmp;

          blink-cmp-fuzzy-lib-native = blink-cmp.passthru.blink-fuzzy-lib.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              ./blink-fuzzy-optimization.patch
            ];
            cargoPatches = (old.cargoPatches or [ ]) ++ [
              ./blink-fuzzy-optimization.patch
            ];

            cargoHash = "";

            env = (old.env or { }) // {
              RUSTFLAGS = prev.lib.concatStringsSep " " [
                (old.env.RUSTFLAGS or "")
                "-C"
                "target-cpu=native"
              ];
            };
          });
        in
        blink-cmp.overrideAttrs (old: {
          preInstall =
            let
              ext = prev.stdenv.hostPlatform.extensions.sharedLibrary;
            in
            ''
              mkdir -p target/release
              ln -s ${blink-cmp-fuzzy-lib-native}/lib/libblink_cmp_fuzzy${ext} target/release/libblink_cmp_fuzzy${ext}
            '';
          passthru = old.passthru // {
            blink-fuzzy-lib = blink-cmp-fuzzy-lib-native;
          };

          patches = (old.patches or [ ]) ++ [
            (prev.writeText "blink-cmp-luasnip-choice-cmp-source-patch" ''
              diff --git a/lua/blink/cmp/lib/text_edits.lua b/lua/blink/cmp/lib/text_edits.lua
              index 93b3d9d..7b124b8 100644
              --- a/lua/blink/cmp/lib/text_edits.lua
              +++ b/lua/blink/cmp/lib/text_edits.lua
              @@ -16,11 +16,14 @@ function text_edits.apply(text_edit, additional_text_edits)
                   'Unsupported mode for text edits: ' .. mode
                 )

                 if mode == 'default' or mode == 'cmdwin' then
                   -- writing to dot repeat may fail in command-line window
              -    if mode == 'default' and config.completion.accept.dot_repeat then text_edits.write_to_dot_repeat(text_edit) end
              +    -- complete() requires insert mode, so skip dot repeat when not in insert mode (e.g. select mode in snippets)
              +    if mode == 'default' and config.completion.accept.dot_repeat and vim.fn.mode() == 'i' then
              +      text_edits.write_to_dot_repeat(text_edit)
              +    end

                   local all_edits = utils.shallow_copy(additional_text_edits)
                   table.insert(all_edits, text_edit)

                   local cur_bufnr = vim.api.nvim_get_current_buf()
            '')
          ];
        });
    }
  );
}
