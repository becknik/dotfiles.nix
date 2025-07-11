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
    marksman.extraOptions.root_dir.__raw = ''
      function(fname)
        if vim.bo.buftype ~= "" or not vim.bo.modifiable then
          return
        end

        -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/marksman.lua
        return require'lspconfig.util'.root_pattern('.marksman.toml')(fname)
          or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
      end,
    '';
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

    # General Scripting Stuff

    pyright.enable = true;
    pyright.package = pkgs.basedpyright;

    # Frontend Stuff

    cssls.enable = true;
    # newer than the version in vsocde-languageservers-extracted
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

    eslint.enable = true;
    eslint.settings.run = "onSave";
    stylelint_lsp.enable = true;
    tailwindcss.enable = true;
    ## Frameworks
    relay_lsp.enable = true;
    relay_lsp.package = null;
    relay_lsp.extraOptions.root_dir.__raw = ''
      function(fname)
        if vim.bo.buftype ~= "" or not vim.bo.modifiable then
          return
        end

        -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/relay_lsp.lua
        return require'lspconfig.util'.root_pattern('relay.config.*')(fname) -- removed 'package.json'
      end
    '';
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
    gopls.enable = true;
  };
}
