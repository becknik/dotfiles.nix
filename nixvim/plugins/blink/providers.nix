{ ... }:

{
  plugins.blink-cmp-git.enable = true;

  plugins.blink-cmp.settings.sources = {
    default = [
      "lsp"
      "path"
      "buffer"
      "git"
    ];

    providers = {
      # TODO: only appear in comments or in gitcommit messages
      git = {
        module = "blink-cmp-git";
        name = "git";
        score_offset = 100;
        opts = {
          commit = { };
          git_centers = {
            git_hub = { };
          };
        };
      };
    };
  };
}
