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
        mappings = rec {
          n."q" = "close";
          n."dd" = "delete_buffer";

          # fix quickfix setup in tmux
          n."<C-q>" = false;
          i."<C-q>" = false;
          n."<C-l>".__raw = "require'telescope.actions'.smart_send_to_qflist";
          i."<C-l>" = n."<C-l>";
          n."<C-a>".__raw = "require'telescope.actions'.add_to_qflist";
          i."<C-a>" = n."<C-a>";
        };
      };
    };
  };

  dependencies.ripgrep.package = pkgs.ripgrep.overrideAttrs (prev: {
    # fix: cargo-build-hook.sh/nix-support/setup-hook: line 10: export: `CARGO_PROFILE_RELEASE-LTO_STRIP=false': not a valid iden…
    cargoBuildType = "releaselto";
    postPatch = ''
      substituteInPlace Cargo.toml \
        --replace-fail 'release-lto' 'releaselto'
    '';

    env = (prev.env or { }) // {
      RUSTFLAGS = pkgs.lib.concatStringsSep " " [
        "-C"
        "target-cpu=native"
      ];
    };
  });
}
