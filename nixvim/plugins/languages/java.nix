{ lib, pkgs, helpers, ... }:

{
  # TODO jdtls dap integration...
  # https://sookocheff.com/post/vim/neovim-java-ide/#language-server--eclipsejdtls
  plugins.nvim-jdtls = {
    enable = true;

    extraOptions = {
      # https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#configuration-verbose
      cmd.__raw = ''
        {
          "${lib.getExe pkgs.jdt-language-server}",
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx2g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens', 'java.base/java.util=ALL-UNNAMED',
          '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
          '-data', os.getenv("HOME") .. '/.cache/jdtls/workspace' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
          '-configuration', os.getenv("HOME") .. '/.cache/jdtls/config',
        }
      '';
      on_attach = ''
        function(client, bufnr)
          require('jdtls').setup_dap({ hotcodereplace = 'auto' })

        end
      '';
    };

    rootDir = helpers.mkRaw "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'build.gradle', 'pom.xml'})";

    # https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    settings = {
      java = {
        implementationsCodeLens.enable = true;
        referenceCodeLens.enable = true;
        signatureHelp.enable = true;

        # TODO fernflower isn't in nixpkgs rn https://github.com/NixOS/nixpkgs/issues/208672
        # contentProvider.preferred = "fernflower"; # decompilation
        configuration.updateBuildConfiguration = "interactive"; # default
        import = { gradle.enabled = true; maven.enabled = true; };
        saveActions.organizeImports = true;

        codeGeneration = {
          useBlocks = true;
          generateComments = true;
          hashCodeEquals = { useInstanceof = true; useJava7Objects = true; };
          toString = {
            # codeStyle?: string;
            # limitElements?: number;
            # listArrayContents?: boolean;
            # skipNullValues?: boolean;
            # template?: string;
          };
        };

        configuration.runtimes = [
          {
            name = "JavaSE-11";
            path = "${pkgs.temurin-bin-11}";
          }
          {
            name = "JavaSE-17";
            path = "${pkgs.temurin-bin-17}";
            default = true;
          }
          {
            name = "JavaSE-21";
            path = "${pkgs.temurin-bin-21}";
          }
        ];
        home = { };
        format.settings = { }; # url profile
      };
    };
  };
}
