{ pkgs-unstable, nixvim, ... }:

{
  nixvim =
    let
      defaultKeymapOptions = {
        nowait = true; # Equivalent to adding <nowait> to a mapping
        silent = true; # no command line echo (might be dangerous??)
        unique = false; # check for accidental duplicate mappings
        # TODO unique leads to errors on mappings like `<leader>wl`, `<leader>f`, K (which doesn't make any sense to me)
      };
      withDefaultKeymapOptions = keymaps: map
        (keymap:
          let
            shouldWrapInCmd = (builtins.hasAttr "options" keymap)
              && (builtins.hasAttr "cmd" keymap.options)
              && keymap.options.cmd != null;
            keymap' =
              if shouldWrapInCmd then keymap // {
                action = "<cmd>${keymap.action}<CR>";
                options = builtins.removeAttrs keymap.options [ "cmd" ];
              } else keymap;

            isModeSet = builtins.hasAttr "mode" keymap';
            keymap'' = if isModeSet then keymap' else keymap' // {
              mode = [ "n" ];
            };
          in
          { options = defaultKeymapOptions; } // keymap'')
        keymaps;

      fetchFromGitHub = pkgs-unstable.fetchFromGitHub;

      # https://neovim.io/doc/user/map.html#%3Amap-modes
      neovimModePrimitives = {
        default = ""; # :map (normal+visual+operator)
        normal = "n"; # :nmap
        insert_cmdline = "!"; # :map! (insert+cmdline)
        insert = "i"; # :imap
        cmdline = "c"; # :cmap
        visual_select = "v"; # :vmap (visual + select)
        visual = "x"; # :xmap (visual only)
        select = "s"; # :smap (select only)
        operator_pending = "o"; # :omap
        terminal = "t"; # :tmap
        lang_arg = "l"; # :lmap (insert + cmdline + lang-arg)
        insert_all = "ia"; # “ia” ???
        cmdline_all = "ca"; # “ca” ???
      };
      mapToModeAbbr = modes:
        builtins.map
          (m:
            if builtins.hasAttr m neovimModePrimitives then
              neovimModePrimitives.${m}
            else
              builtins.throw "Unknown mode ‘${m}’"
          )
          modes;

    in
    nixvim.makeNixvimWithModule {
      pkgs = pkgs-unstable;

      module = ../nixvim;
      extraSpecialArgs = {
        inherit
          defaultKeymapOptions
          withDefaultKeymapOptions
          mapToModeAbbr
          fetchFromGitHub;
      };
    };

  # example = pkgs.callPackage ./example { };
}
