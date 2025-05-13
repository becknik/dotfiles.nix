{ ... }:

{
  plugins.guess-indent = {
    enable = true;

    settings = {
      auto_cmd = true; # false disables automatic execution

      filetype_exclude = [
        "markdown"
      ];
      buftype_exclude = [
        "help"
        "nofile"
        "terminal"
        "prompt"
      ];
    };
  };
}
