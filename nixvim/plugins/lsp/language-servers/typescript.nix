{ ... }:

{
  lsp.servers.vtsls = {
    enable = true;

    config = {
      # https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
      settings = rec {
        refactor_auto_rename = true;
        complete_function_calls = true;

        vtsls = {
          autoUseWorkspaceTsdk = true;
          enableMoveToFileCodeAction = true;

          experimental.completion.enableServerSideFuzzyMatch = true;
        };

        typescript = {
          suggest.completeFunctionCalls = true;
          updateImportsOnFileMove.enabled = "always";

          preferences = {
            # fixes relative import aliases not being applied
            importModuleSpecifier = "non-relative"; # for monorepos: "project-relative"
            importModuleSpecifierEnding = "minimal";

            includePackageJsonAutoImports = "auto";
            renameMatchingJsxTags = true;
            quoteStyle = "auto";
          };

          tsserver = {
            maxTsServerMemory = 4096;
            useSeparateSyntaxServer = true;
            experimental.enableProjectDiagnostics = true;
          };
        };

        javascript.preferences = typescript.preferences;
        javascript.updateImportsOnFileMove = typescript.updateImportsOnFileMove;
        javascript.suggest = typescript.suggest;
      };
    };
  };
}
