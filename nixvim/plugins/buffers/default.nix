{ ... }:

{
  imports = [
    ./keymaps.nix
    ./cybu.nix
  ];

  plugins.bufdelete.enable = true;
}
