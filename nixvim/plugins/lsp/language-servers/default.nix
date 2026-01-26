{ pkgs, css-variables-language-server, ... }:

{
  imports = [
    ./lua_ls.nix
    ./nix.nix
  ];

  plugins.schemastore.enable = true;
  plugins.lspconfig.enable = true;

  lsp.servers = {
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

    # Domain-specific Scripting Stuff

    sqls.enable = true;
    texlab.enable = true;
    bashls.enable = true;
    tinymist.enable = true;

    # General Scripting Stuff
    basedpyright.enable = true;

    # Frontend Stuff
    vtsls.enable = true;
    cssls.enable = true;
    # newer than the version in vsocde-languageservers-extracted
    # https://github.com/microsoft/vscode-css-languageservice
    cssls.package = pkgs.buildNpmPackage rec {
      name = "vscode-css-languageservice";
      packageName = "vscode-css-languageservice";
      version = "6.3.9";
      src = (
        pkgs.fetchFromGitHub {
          owner = "microsoft";
          repo = "vscode-css-languageservice";
          rev = "v${version}";
          hash = "sha256-BVfNesWL0m9g1cBP+JfQ/gA8ZqJ6ma337RCfSO0jkDg=";
        }
      );
      npmDepsHash = "sha256-4FCzXJc+AcuRhC4MaaTmiKs0ag/G/gHG0W1hVx7BoEg=";
      npmBuildScript = "test";
    };
    tailwindcss.enable = true;

    eslint.enable = true;
    eslint.config.settings.codeActionOnSave.enable = true;
    stylelint_lsp.enable = true;

    ## Frameworks
    astro.enable = true;
    svelte.enable = true;
    vue_ls.enable = true;

    # Backend Stuff

    clangd.enable = true;
    rust_analyzer.enable = true;
    hls.enable = true;
    # zls.enable = true;
    gopls.enable = true;
  };

  plugins.lsp.servers = {
    gh_actions_ls.enable = true;
    gh_actions_ls.package = null;

    cssmodules_ls.enable = true;
    cssmodules_ls.onAttach.function = /* lua */ ''
      -- avoid accepting `definitionProvider` responses from this LSP
      client.server_capabilities.definitionProvider = false
    '';
    # https://github.com/antonk52/cssmodules-language-server
    cssmodules_ls.package = pkgs.buildNpmPackage rec {
      name = "cssmodules-language-server";
      packageName = "cssmodules-language-server";
      version = "1.5.2";
      src = (
        pkgs.fetchFromGitHub {
          owner = "antonk52";
          repo = "cssmodules-language-server";
          rev = "v${version}";
          hash = "sha256-9RZNXdmBP4OK7k/0LuuvqxYGG2fESYTCFNCkAWZQapk=";
        }
      );
      npmDepsHash = "sha256-1CnCgut0Knf97+YHVJGUZqnRId/BwHw+jH1YPIrDPCA=";
      # npmBuildScript = "test";
    };

    css_variables.enable = true;
    css_variables.package = css-variables-language-server;
  };
}
