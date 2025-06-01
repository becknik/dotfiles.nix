{ ... }:

{
  imports = [
    ./trouble.nix
    ./keymaps.nix
  ];

  diagnostic.settings = {
    virtual_text = true;
  };
}
