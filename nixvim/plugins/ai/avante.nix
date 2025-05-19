{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.avante = {
    enable = true;

    settings = {
      provider = "copilot";
      auto_suggestions_provider = "copilot";

      windows = {
        width = 35; # %
        sidebar_header.enabled = false;
        input.height = 12;
      };

      mappings = {
        sidebar.add_file = "f"; # for "find"
      };
    };
  };

  keymaps = withDefaultKeymapOptions [];
}
