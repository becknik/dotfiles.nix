{
  pkgs-unstable,
  nixvim,
  pkgs,
  ...
}:

{
  nixvim =
    let
      defaultKeymapOptions = {
        nowait = false; # Equivalent to adding <nowait> to a mapping
        unique = true; # check for accidental duplicate mappings
      };
      withDefaultKeymapOptions =
        keymaps:
        map (
          keymap:
          let
            shouldWrapInCmd =
              (builtins.hasAttr "options" keymap)
              && (builtins.hasAttr "cmd" keymap.options)
              && keymap.options.cmd != null;
            keymap' =
              if shouldWrapInCmd then
                keymap
                // {
                  action = "<cmd>${keymap.action}<CR>";
                  options = builtins.removeAttrs keymap.options [ "cmd" ];
                }
              else
                keymap;

            isModeSet = builtins.hasAttr "mode" keymap';
            keymap'' =
              if isModeSet then
                keymap'
              else
                keymap'
                // {
                  mode = [ "n" ];
                };
          in
          { options = defaultKeymapOptions; } // keymap''
        ) keymaps;

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
      mapToModeAbbr =
        modes:
        builtins.map (
          m:
          if builtins.hasAttr m neovimModePrimitives then
            neovimModePrimitives.${m}
          else
            builtins.throw "Unknown mode ‘${m}’"
        ) modes;
    in
    nixvim.makeNixvimWithModule {
      pkgs = pkgs-unstable;

      module = ../nixvim;
      extraSpecialArgs = {
        inherit
          defaultKeymapOptions
          withDefaultKeymapOptions
          mapToModeAbbr
          fetchFromGitHub
          ;
      };
    };

  chromium-app-t3-chat = pkgs.callPackage ./t3-chat/package.nix { inherit pkgs; };
}
