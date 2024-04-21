{ pkgs-unstable, nixvim, ... }:

{
  nixvim =
    let
      defaultKeymapOptions = {
        nowait = true; # Equivalent to adding <nowait> to a mapping
        noremap = true; # default
        silent = true; # no command line echo
        unique = false; # check for accidental duplicate mappings
        # TODO unique leads to errors on mappings like `<leader>wl`, `<leader>f`, K (which doesn't make any sense to me)
      };
      withDefaultKeymapOptions = keymaps: map (keymap: { options = defaultKeymapOptions; } // keymap) keymaps;
    in
    nixvim.makeNixvimWithModule {
      pkgs = pkgs-unstable;

      module = ../nixvim;
      extraSpecialArgs = { inherit defaultKeymapOptions withDefaultKeymapOptions; };
    };

  # example = pkgs.callPackage ./example { };
}
