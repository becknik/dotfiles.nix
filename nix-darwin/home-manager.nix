{ stateVersion, defaultUser, pkgs, ... }:

{
  home = {
    inherit stateVersion;

    username = defaultUser;
    homeDirectory = "/Users/${defaultUser}";
  };

  programs.home-manager.enable = true;
}
