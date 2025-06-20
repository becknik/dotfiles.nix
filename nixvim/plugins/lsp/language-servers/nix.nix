{ ... }:

{
  plugins.lsp.servers.nixd = {
    enable = true;

    settings = {
      # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
      nixpkgs.expr = "import (builtins.getFlake (\"git+file://\" + toString ./.)).inputs.nixpkgs { }";
      options = {
        nixos.expr = "(builtins.getFlake (\"git+file://\" + toString ./.)).nixosConfigurations.dnix.options";
        home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.dnix.options.home-manager.users.type.getSubOptions []";
        darwin.expr = "(builtins.getFlake (\"git+file://\" + toString ./.)).darwinConfigurations.wnix.options";
      };
    };
  };
}
