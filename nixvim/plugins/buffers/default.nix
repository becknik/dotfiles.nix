{ ... }:

{
  imports = [
    ./bufferline.nix
    ./keymaps.nix
    ./scope.nix
  ];

  plugins.bufdelete.enable = true;
}
