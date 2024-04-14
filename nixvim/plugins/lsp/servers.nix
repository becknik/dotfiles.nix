{ ... }:

{
  plugins.lsp.servers = {
    typos-lsp.enable = true; # Source code spell checker for Visual Studio Code

    html.enable = true;
    #templ.enable = true; # HTML
    lemminx.enable = true;
    jsonls.enable = true;
    marksman.enable = true;
    taplo.enable = true; # TOML
    yamlls.enable = true;

    dockerls.enable = true;

    # rnix-lsp.enable = true;
    sqls.enable = true;
    texlab.enable = true;

    lua-ls.enable = true;
    bashls.enable = true;
    pyright.enable = true;

    eslint.enable = true;
    tsserver.enable = true;

    clangd.enable = true;
    rust-analyzer = {
      enable = true;
      installCargo = false; # TODO is working with rustup?
      installRustc = false;
    };
    hls.enable = true;
    # zls.enable = true;

    java-language-server.enable = true;
    kotlin-language-server.enable = true;
    # metals.enable = true;
  };
}