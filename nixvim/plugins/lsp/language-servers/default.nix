{ pkgs, ... }:

{
  imports = [
    ./lua_ls.nix
    ./nix.nix
  ];

  plugins.schemastore.enable = true;

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

    # CI/CD Stuff

    dockerls.enable = true;
    docker_compose_language_service.enable = true;
    gh_actions_ls.enable = true;
    gh_actions_ls.package = null;

    # Domain-specific Scripting Stuff

    sqls.enable = true;
    texlab.enable = true;
    bashls.enable = true;
    tinymist.enable = true;

    # General Scripting Stuff

    pyright.enable = true;
    pyright.package = pkgs.basedpyright;

    # Frontend Stuff
    vtsls.enable = true;
    cssmodules_ls.enable = true;
    # https://github.com/antonk52/cssmodules-language-server
    cssmodules_ls.package = pkgs.buildNpmPackage rec {
      name = "cssmodules-language-server";
      packageName = "cssmodules-language-server";
      version = "1.5.1";
      src = (
        pkgs.fetchFromGitHub {
          owner = "antonk52";
          repo = "cssmodules-language-server";
          rev = "v${version}";
          hash = "sha256-MpUZn+UaelnCoyokPszc+Q566zs0BzKFAytWdRuOJ8U=";
        }
      );
      npmDepsHash = "sha256-qvQtWMGKRU7CcAE/ozv1cr+tlDrdp+PfQrh8ouTmX2A=";
      # npmBuildScript = "test";
    };
    cssls.enable = true;
    # newer than the version in vsocde-languageservers-extracted
    # https://github.com/microsoft/vscode-css-languageservice
    cssls.package = pkgs.buildNpmPackage rec {
      name = "vscode-css-languageservice";
      packageName = "vscode-css-languageservice";
      version = "6.3.7";
      src = (
        pkgs.fetchFromGitHub {
          owner = "microsoft";
          repo = "vscode-css-languageservice";
          rev = "v${version}";
          hash = "sha256-llBkseQgIPtzGkYl92s9IrKPIL9RRq7/V11AlK36UtA=";
        }
      );
      npmDepsHash = "sha256-DICiBn8fRqJl8A5NimAFOHzvQYvP3j4mIvGrji2svOc=";
      npmBuildScript = "test";
    };
    tailwindcss.enable = true;

    eslint.enable = true;
    eslint.settings.run = "onSave";
    stylelint_lsp.enable = true;

    ## Frameworks
    astro.enable = true;
    svelte.enable = true;
    vue_ls.enable = true;

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
    gopls.enable = true;
  };
}
