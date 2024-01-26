{ stateVersion, defaultUser, lib, pkgs, ... }:

{
  home = {
    inherit stateVersion;

    username = defaultUser;
    homeDirectory = (lib.mkDefault "/Users/${defaultUser}");
  };

  programs.home-manager.enable = true;
}
