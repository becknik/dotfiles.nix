{ pkgs, ... }:

{
  imports = [
    ./extensions
    ./keymaps.nix
  ];

  plugins.telescope = {
    enable = true;
    package = pkgs.vimPlugins.telescope-nvim.overrideAttrs (oldAttrs: {
      patches = [ ./telescope-fname.patch ];
    });

    settings = {
      defaults = {
        file_ignore_patterns = [ "^.git/" ];
        dynamic_preview_title = true; # necessary for neoclip previews

        # https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
        # https://github.com/nvim-telescope/telescope.nvim/tree/master?tab=readme-ov-file#default-mappings
        mappings = {
          n."q" = "close";
          n."dd" = "delete_buffer";
        };
      };
    };
  };

  # dependencies.ripgrep.package = pkgs.ripgrep.overrideAttrs (prev: {
  #   # cargo-build-hook.sh/nix-support/setup-hook: line 10: export: `CARGO_PROFILE_RELEASE-LTO_STRIP=false': not a valid iden…
  #   cargoBuildType = "releaselto";
  #   postPatch = ''
  #     substituteInPlace Cargo.toml \
  #       --replace '[profile.release-lto]' '[profile.releaselto]'
  #   '';
  #
  #   env = (prev.env or { }) // {
  #     RUSTFLAGS = pkgs.lib.concatStringsSep " " [
  #       "-C"
  #       "target-cpu=native"
  #     ];
  #   };
  # });
}
