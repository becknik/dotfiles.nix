{ ... }:

final: prev: {
  librewolf-unwrapped = prev.librewolf-unwrapped.overrideAttrs (oldAttrs:
    let
      # Source: https://firefox-source-docs.mozilla.org/setup/configuring_build_options.html
      configureFlags' = prev.lib.lists.subtractLists [ "--enable-debug-symbols" ] oldAttrs.configureFlags;
      # --enable-optimize --enable-default-toolkit=cairo-gtk3-wayland --enable-lto=cross
      configureFlags'' = configureFlags' ++ [ "--disable-debug-symbols" "--enable-rust-simd" ];
      # When option is specified multiple times the last option is applied by mozbuild
      # ''--enable-optimize="-march=native,-O3"'' doesn't work due to '\' not being removed from nix-string...
      # -> https://discourse.nixos.org/t/character-escaping-remove-from-escaped-string/37444
      # "--enable-default-toolkit=cairo-gtk3-wayland-only": crashes in profiling phase
      # "--enable-lto=cross,full": to much RAM usage...
    in
    {
      #depsBuildBuild = [ pkgs.egl-wayland ];
      configureFlags = configureFlags'';
      preConfigure = oldAttrs.preConfigure + "export RUSTFLAGS=\"-C debuginfo=0 -C target-cpu=native -C opt-level=3\"\n";
    });
}
