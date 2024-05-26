{ stateVersion, userName, config, lib, ... }:

{
  imports = [
    # This module extends home.file, xdg.configFile and xdg.dataFile with the `mutable` option.
    (import
      (builtins.fetchurl {
        url = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375/mutability.nix";
        sha256 = "4b5ca670c1ac865927e98ac5bf5c131eca46cc20abf0bd0612db955bfc979de8";
      })
      { inherit config lib; })
  ];

  home = {
    inherit stateVersion;

    # Home Manager needs a bit of information about you and the paths it should manage.
    username = userName;
  };

  # Lets Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
