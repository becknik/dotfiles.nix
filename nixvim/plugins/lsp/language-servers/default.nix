{ pkgs, ... }:

{
  imports = [
    ./lua_ls.nix
    ./nix.nix
  ];

  plugins.lsp.servers = {
    typos_lsp.enable = true; # Source code spell checker for Visual Studio Code

    # I programmed in HTML stuff

    html.enable = true;
    #templ.enable = true; # HTML
    # lemminx.enable = true; # TODO fails to build on aarch64-darwin
    jsonls.enable = true;
    marksman.enable = true;
    taplo.enable = true; # TOML
    yamlls.enable = true;

    # Templating Stuff

    dockerls.enable = true;
    docker_compose_language_service.enable = true;

    # Domain-specific Scripting Stuff

    sqls.enable = true;
    texlab.enable = true;
    bashls.enable = true;

    # General Scripting Stuff

    pyright.enable = true;
    pyright.package = pkgs.basedpyright;

    # Frontend Stuff

    eslint.enable = true;
    eslint.settings.run = "onSave";
    stylelint_lsp.enable = true;
    tailwindcss.enable = true;
    ## Frameworks
    relay_lsp.enable = true;
    relay_lsp.package = null;
    relay_lsp.rootMarkers = [
      "relay.config.json"
      "relay.config"
    ];
    volar.enable = true;
    vtsls.enable = true;

    # Backend Stuff

    clangd.enable = true;
    rust_analyzer = {
      enable = true;
      installCargo = false; # TODO is working with rustup?
      installRustc = false;
    };
    hls.enable = true;
    hls.installGhc = true;
    # zls.enable = true;
  };
}
